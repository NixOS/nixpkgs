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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${version}";
    hash = "sha256-zqJL/eeTl1cekLlJess2IH8piEZpn2ubTB2NRsj8OjQ=";
  };

  npmDepsHash = "sha256-GdoVwBU/uSk1g+7R2kg8tExAXagdVelaj6xii+NRf/w=";

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
