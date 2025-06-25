{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo124Module rec {
  pname = "matrix-alertmanager-receiver";
  version = "2025.6.25";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = version;
    hash = "sha256-yB4Yjn1E2qc9Ly64QkBkX1dTZ61YphMN6Y0u2irVxEk=";
  };

  vendorHash = "sha256-H8zmh76Sl2F/BnTN6FQz/SGAbQwNuXYnTzbhSOCLrXA=";

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
