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
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "whiteboard";
    rev = "refs/tags/v${version}";
    hash = "sha256-27w8FZz9PbVdYV7yR5iRXi5edw7U/3bLVYfdRa8yPzo=";
  };

  npmDepsHash = "sha256-SwFQRDRo7Q8+0zYWx5szahJzDSoxkkJDPQ3qEdNLVaE=";

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
