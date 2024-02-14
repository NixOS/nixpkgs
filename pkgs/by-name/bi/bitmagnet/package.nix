{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-17jRktEqBCAXiddx8FnqHg3+c/03nqKHC8BQc9AhQA0=";
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
