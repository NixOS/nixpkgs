{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "bitmagnet";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "bitmagnet-io";
    repo = "bitmagnet";
    rev = "v${version}";
    hash = "sha256-IUWt6CBW2SXE6lc52ArKrmW+7uR1vczfbx4SOeE30IA=";
  };

  vendorHash = "sha256-aauXgHPZbSiTW9utuHXzJr7GsWs/2aFiGuukA/B9BRc=";

  ldflags = [ "-s" "-w" "-X github.com/bitmagnet-io/bitmagnet/internal/version.GitTag=v${version}" ];

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
