{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-P5GfPRIrwLLMBRgoN6d092HiThMghEj1zcaf6BU+IWU=";
  };

  vendorHash = "sha256-exKQTsyP7LL63WHZ8/WchLh4y0Oj9LC4lxiZTOfWARU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bitmagnet-io/bitmagnet/internal/version.GitTag=v${version}"
  ];

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
