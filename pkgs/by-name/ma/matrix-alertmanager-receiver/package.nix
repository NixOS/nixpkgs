{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo124Module rec {
  pname = "matrix-alertmanager-receiver";
  version = "2025.3.19";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = version;
    hash = "sha256-uNQU0E2QItXK5VCwFDC4tZZIIECXhas5SMSOTYj9zlo=";
  };

  vendorHash = "sha256-u1oTutEEYZ79Ne27Tu4S5eDuUIlVamsFR2WR6O+giM8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.matrixAlertmanagerReceiverVersion=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Alertmanager client that forwards alerts to a Matrix room";
    homepage = "https://github.com/metio/matrix-alertmanager-receiver";
    changelog = "https://github.com/metio/matrix-alertmanager-receiver/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "matrix-alertmanager-receiver";
  };
}
