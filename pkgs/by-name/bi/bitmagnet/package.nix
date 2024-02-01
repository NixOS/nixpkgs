{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-tqxmPr7O3WkFgo8tYk4iFr/k76Z5kq75YF+6uDuBOik=";
  };

  vendorHash = "sha256-YfsSz72CeHdrh5610Ilo1NYxlCT993hxWRWh0OsvEQc=";

  ldflags = [ "-s" "-w" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A self-hosted BitTorrent indexer, DHT crawler, and torrent search engine";
    longDescription = ''
      A self-hosted BitTorrent indexer, DHT crawler, content classifier and torrent search engine with web UI, GraphQL API and Servarr stack integration.
    '';
    homepage = "https://bitmagnet.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant viraptor ];
    mainProgram = "bitmagnet";
  };
}
