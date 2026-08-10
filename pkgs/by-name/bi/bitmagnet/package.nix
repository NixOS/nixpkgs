{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bitmagnet";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lnYoJbqE936IR8MJZT3ETR4pKuVNjgmfQEa6wK7HEEU=";
  };

  vendorHash = "sha256-9qvBVCSvHdS2K9Soly9CVu/HoxXclw444WWEWYTlOJM=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/bitmagnet-io/bitmagnet/internal/version.GitTag=v${finalAttrs.version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted BitTorrent indexer, DHT crawler, and torrent search engine";
    longDescription = ''
      A self-hosted BitTorrent indexer, DHT crawler, content classifier and torrent search engine with web UI, GraphQL API and Servarr stack integration.
    '';
    homepage = "https://bitmagnet.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "bitmagnet";
  };
})
