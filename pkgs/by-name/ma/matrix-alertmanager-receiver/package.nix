{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo124Module rec {
  pname = "matrix-alertmanager-receiver";
  version = "2025.4.16";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = version;
    hash = "sha256-QxBe9WkUg6TTAgxC29kLyQzJSR6m0to0ayH+0vT9pgQ=";
  };

  vendorHash = "sha256-okaNjcA1fFChqaCooviPDW2VZTae9pUEGKNOTUxSSQ0=";

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
