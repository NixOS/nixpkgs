{ buildGoModule
, fetchFromGitHub
, lib
, go
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" "kvdb_postgres" "kvdb_etcd" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.17.3-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-JZ+DhFIDMRDDeW6YNeUy/pQt+IbFyZiiqFn4//S2Oao=";
  };

  vendorHash = "sha256-lvysD9/26OoPCKBOGu/R95x1UKvhcLtn17bQLPT4ofM=";

  subPackages = [ "cmd/lncli" "cmd/lnd" ];

  inherit tags;

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 prusnak ];
  };
}
