{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo124Module rec {
  pname = "matrix-alertmanager-receiver";
  version = "2025.3.26";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = version;
    hash = "sha256-IIuYsuNEQheMZmhU06kkz9wP75s53Nl/nGDqdlebnL8=";
  };

  vendorHash = "sha256-aMk82HLfuIP+HEFinVUf4WXZC3y6RAUhf/e+ZwXD46k=";

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
