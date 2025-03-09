{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_24,
  pkg-config,
  nix-update-script,
}:

buildGoModule.override { go = go_1_24; } rec {
  pname = "matrix-alertmanager-receiver";
  version = "2025.2.19";

  src = fetchFromGitHub {
    owner = "metio";
    repo = "matrix-alertmanager-receiver";
    tag = version;
    hash = "sha256-mzWxAR82tD5zbviAjRFyBLZSpaETti85kzolWRmhx1o=";
  };

  vendorHash = "sha256-lRZGnkcdQtU9ecM6ezm97YtMzC/65yEgzJ99iKWY4QY=";

  nativeBuildInputs = [
    pkg-config
  ];

  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
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
