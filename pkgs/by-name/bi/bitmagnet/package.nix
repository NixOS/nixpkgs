{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.7.14";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-TaxoQdjdHw8h6w6wKBHL/CVxWFK/RG2tJ//MtUEOwfU=";
  };

  vendorHash = "sha256-y9RfaAx9AQS117J3+p/Yy8Mn5In1jmZmW4IxKjeV8T8=";

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
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "bitmagnet";
  };
}
