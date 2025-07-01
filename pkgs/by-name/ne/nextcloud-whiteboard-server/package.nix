{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  nodejs,
}:
buildNpmPackage rec {
  pname = "nextcloud-whiteboard-server";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${version}";
    hash = "sha256-nDZnO1aqOP78xqcQKBJd7B8idG3Jbjqj5ifWqMslB6M=";
  };

  npmDepsHash = "sha256-EiD1fAT6i8V1arXBNaqHk8GvAgetL3VZT9d2/3zPIj8=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/nextcloud-whiteboard-server" \
      --add-flags "$out/lib/node_modules/whiteboard/websocket_server/main.js"
  '';

  meta = {
    description = "Backend server for the Nextcloud Whiteboard app";
    homepage = "https://apps.nextcloud.com/apps/whiteboard";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "nextcloud-whiteboard-server";
  };
}
