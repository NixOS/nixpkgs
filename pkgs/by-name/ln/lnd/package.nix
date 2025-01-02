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
  version = "0.18.4-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-vZ5A0AsxZ8gpvXB4tH+GQIIvlJbSFvk38UbR24BVOPc=";
  };

  vendorHash = "sha256-Irlf2dwI0QZyzMFeBVr2I5iUe0PJyv20HX4rPOE8M54=";

  subPackages = [
    "cmd/lncli"
    "cmd/lnd"
  ];

  inherit tags;

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = licenses.mit;
    maintainers = with maintainers; [
      cypherpunk2140
      prusnak
    ];
  };
}
