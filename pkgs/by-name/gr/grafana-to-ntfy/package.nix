{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "grafana-to-ntfy";
  version = "0-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "kittyandrew";
    repo = "grafana-to-ntfy";
    rev = "64d11f553776bbf7695d9febd74da1bad659352d";
    hash = "sha256-GO9VE9wymRk+QKGFyDpd0wS9GCY3pjpFUe37KIcnKxc=";
  };

  cargoHash = "sha256-w4HSxdihElPz0q05vWjajQ9arZjAzd82L0kEKk1Uk8s=";

  meta = {
    description = "Bridge to forward Grafana alerts to ntfy.sh notification service";
    homepage = "https://github.com/kittyandrew/grafana-to-ntfy";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ kranzes ];
    mainProgram = "grafana-to-ntfy";
  };
}
