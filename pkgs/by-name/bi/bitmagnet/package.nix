{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-+KAIHg8M2CM+GRRv+htmev8MFe/Y1sJ8p+um/c7kI7c=";
  };

  vendorHash = "sha256-ydiZ3KMEiVkmdzhHjYYLJ7wuiKmwlMEn4OWrKSOnaSo=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "A self-hosted BitTorrent indexer, DHT crawler, and torrent search engine";
    longDescription = ''
      A self-hosted BitTorrent indexer, DHT crawler, content classifier and torrent search engine with web UI, GraphQL API and Servarr stack integration.
    '';
    homepage = "https://bitmagnet.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "bitmagnet";
  };
}
