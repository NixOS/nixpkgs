{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ccmeter";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hmenzagh";
    repo = "CCMeter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iVPHRV+qfLl77wdyGLycYCYbtMLh3KF+TFwFI8qZPNs=";
  };

  cargoHash = "sha256-owQwUm8jbi3GItHV7UUfxyNn+htHfXEP/OfJjVLxFzs=";

  # These tests hardcode 2026-04-01 timestamps, but discover_rate_limit_hits()
  # discards hits older than 30 days, so they only pass within a month of the
  # release date:
  # https://github.com/hmenzagh/CCMeter/blob/v2.0.0/src/data/rate_limits.rs#L180-L182
  checkFlags = [
    "--skip=data::rate_limits::tests::detects_rate_limit_hit"
    "--skip=data::rate_limits::tests::deduplicates_same_minute"
  ];

  meta = {
    description = "TUI dashboard for tracking Claude Code usage and costs";
    homepage = "https://github.com/hmenzagh/CCMeter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
    platforms = lib.platforms.unix;
    mainProgram = "ccmeter";
  };
})
