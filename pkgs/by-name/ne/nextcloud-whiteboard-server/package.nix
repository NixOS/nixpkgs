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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    rev = "refs/tags/v${version}";
    hash = "sha256-RoizzsSQHe2Tw52VcaqTGjbLS50VgTxk09yTIqkoyh4=";
  };

  npmDepsHash = "sha256-RZoMvDwTANdMm0+Z4SU2ifz7FgXQH+NdrKNspudgQTY=";

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
