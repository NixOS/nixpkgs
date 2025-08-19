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
  version = "0.19.2-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-LUBUODPKXqU/wzQhjmC0NfvM284sD5dc7iQFSsdzyyI=";
  };

  vendorHash = "sha256-3eOKZ/NgSPrtYfDYUTDnVVb7EyMz8s+mtFo2UMyieHY=";

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
      bleetube
      cypherpunk2140
      prusnak
    ];
  };
}
