{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "grafana-to-ntfy";
  version = "2026.3.15";

  src = fetchFromGitHub {
    owner = "kittyandrew";
    repo = "grafana-to-ntfy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jK/UTgazDlVaIAD0AM61i0dAVX41LCPJFGf1tfMhNk0=";
  };

  cargoHash = "sha256-/e9dDcoablMSLb8q0DPUqNExPny13fm/xBhUT46hkXQ=";

  # No unit tests; all testing is NixOS VM-based integration tests
  doCheck = false;

  passthru = {
    tests.grafana-to-ntfy = nixosTests.grafana-to-ntfy;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bridge to forward Grafana and Prometheus Alertmanager alerts to ntfy.sh";
    homepage = "https://github.com/kittyandrew/grafana-to-ntfy";
    changelog = "https://github.com/kittyandrew/grafana-to-ntfy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kittyandrew ];
    mainProgram = "grafana-to-ntfy";
  };
})
