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
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${version}";
    hash = "sha256-WdaAMSID8MekVL6nA8YRWUiiI+pi1WgC0nN3dDAJHf8=";
  };

  npmDepsHash = "sha256-T27oZdvITj9ZCEvd13fDZE3CS35XezgVmQ4iCeN75UA=";

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
  };
}
