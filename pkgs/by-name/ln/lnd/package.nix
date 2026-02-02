{
  buildGoModule,
  fetchFromGitHub,
  lib,
  tags ? [
    # `RELEASE_TAGS` from https://github.com/lightningnetwork/lnd/blob/master/make/release_flags.mk
    "autopilotrpc"
    "chainrpc"
    "invoicesrpc"
    "kvdb_etcd"
    "kvdb_postgres"
    "kvdb_sqlite"
    "monitoring"
    "neutrinorpc"
    "peersrpc"
    "signrpc"
    "walletrpc"
    "watchtowerrpc"
    # Extra tags useful for testing
    "routerrpc"
  ],
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.20.0-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-N8eZacu8BHMiI8RyueBv+Y1bWlaEuCQLRsfIj5WviV4=";
  };

  vendorHash = "sha256-3F2ERp8gosNFzsg2QqSJpmjewf6N0zho+st+pafP8F0=";

  subPackages = [
    "cmd/lncli"
    "cmd/lnd"
  ];

  env.CGO_ENABLED = 0;

  inherit tags;

  meta = {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bleetube
      cypherpunk2140
      prusnak
    ];
  };
}
