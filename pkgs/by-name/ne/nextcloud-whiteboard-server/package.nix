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
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    tag = "v${version}";
    hash = "sha256-4qk6mAFz7bYWtrlqiVPiyWF4ub4Ks9RhS5oODlOYRvA=";
  };

  npmDepsHash = "sha256-WHSMK7s6vohphHoNh96yejdwXHBxdkQSpMMNiFS15E4=";

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
