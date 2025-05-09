{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo124Module rec {
  pname = "matrix-alertmanager-receiver";
  version = "2025.4.23";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = version;
    hash = "sha256-ubSrj8mUc0b6fwRuvaw8oapTyIbDRvlzEqpjIFEY1FQ=";
  };

  vendorHash = "sha256-8LQ4SJ1zapBRuFDX8VxYUvA6jzukVml8Jr+B3zQKFOs=";

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
