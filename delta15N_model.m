% δ15N model with modern mode and N2 fixation fractionation range, no denitrification lines
pan_sub = linspace(0, 100, 1000);

delta_fix = -1;         % δ15N of N2 fixation
delta_water = 26;       % δ15N of water column denitrification (mean value)
delta_sed = 0;          % δ15N of sedimentary denitrification
uncertainty_sigma = 1;  % ±1σ for model curve

% Denitrification fluxes modeled as functions of pan-suboxic extent
f_denit_water = exp(-((pan_sub - 50).^2) / (2 * 20^2)); % Gaussian shape peak at 50%
f_denit_sed = 0.3 * (1 - pan_sub / 100);                % Linear decrease with pan-suboxic extent

% Fixation flux increasing with pan-suboxic extent (cubic relation)
F_fix = 1 + 3 * (pan_sub / 100).^3;

% Total flux sum of fixation and denitrification
F_total = F_fix + f_denit_water + f_denit_sed;

% Calculate bulk δ15N weighted by fluxes
delta_bulk = (F_fix .* delta_fix + ...
              f_denit_water .* delta_water + ...
              f_denit_sed .* delta_sed) ./ F_total;

% Upper and lower bounds of model uncertainty (±1σ)
delta_upper = delta_bulk + uncertainty_sigma;
delta_lower = delta_bulk - uncertainty_sigma;

figure('Position', [100, 100, 800, 500]);

% Plot shaded uncertainty range
fill([pan_sub, fliplr(pan_sub)], ...
     [delta_upper, fliplr(delta_lower)], ...
     [1 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'none'); hold on;

% Plot mean model curve and uncertainty bounds
plot(pan_sub, delta_bulk, 'r-', 'LineWidth', 2);
plot(pan_sub, delta_upper, 'r--', 'LineWidth', 1);
plot(pan_sub, delta_lower, 'r--', 'LineWidth', 1);

% N2 fixation fractionation range shaded area
fill([0 100 100 0], [-2 -2 1 1], [1 0.5 0.5], ...
    'FaceAlpha', 0.3, 'EdgeColor', 'none');
text(101, -0.5, 'N₂ fixation range', 'Color', [0.6 0 0], 'FontSize', 9);

% Modern sedimentary δ15N mode and ±1σ (modified to 5‰)
modern_mode = 5;         % changed from 5.4 to 5
modern_sigma = 0.9;

yline(modern_mode, 'Color', [0 0 0.6], 'LineWidth', 3);
fill([0 100 100 0], [modern_mode-modern_sigma modern_mode-modern_sigma modern_mode+modern_sigma modern_mode+modern_sigma], ...
    [0.6 0.8 1.0], 'FaceAlpha', 0.4, 'EdgeColor', 'none');
text(101, modern_mode, 'Modern \delta^{15}N mode (Tesdal et al., 2013)', ...
     'Color', [0 0 0.6], 'FontSize', 9);

% Axes labels and title
xlabel('Pan-sub (% upper ocean with O₂ < 4.5 μM)');
ylabel('\delta^{15}N_{bulk} (‰)');
title('Modeled \delta^{15}N_{bulk} vs. Ocean Anoxia Extent');

% Axis limits and grid
xlim([0 105]);
ylim([-3 12]);
grid on;

% Legend
legend({'±1σ model range', 'Model curve', '+1σ', '-1σ', ...
        'N₂ fixation range', 'Modern mode', 'Modern ±1σ'}, ...
       'Location', 'northwest');
