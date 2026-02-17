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
  version = "0.20.1-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EHyyUleCKLEAnYNH7+PYwE/uTz445EQmtfosFxf10wU=";
  };

  vendorHash = "sha256-jF/yQE0xH0MFKI7CCGHy/HFzp6tgTM5T/MP2uB62vKk=";

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
