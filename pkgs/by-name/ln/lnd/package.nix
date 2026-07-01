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

buildGoModule (finalAttrs: {
  pname = "lnd";
  version = "0.21.1-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LOP5vyffwxzXRI16Jgfjb+JykHcNWrGApM27frYUoPw=";
  };

  vendorHash = "sha256-7fssqutcagEv6JKxwaAp9g3TtxHnQ34Kyln4DIhxjSQ=";

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
})
