{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-KgpKpnOVtS3VoIqKhIzDvbdR54M014tQj2/ufhWMZDo=";
  };

  vendorHash = "sha256-Scper1eR6I4pCXus/jytSpW8a1omg7sJIPvOn3jYcLM=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/bitmagnet-io/bitmagnet/internal/version.GitTag=v${version}"
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
}
