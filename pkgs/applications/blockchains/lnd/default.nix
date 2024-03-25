{ buildGoModule
, fetchFromGitHub
, lib
, go
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" "kvdb_postgres" "kvdb_etcd" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.17.4-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-O6cGK4UMKrZpYqtghjjqqLBStLG5GEi/Q5liR557I8s=";
  };

  vendorHash = "sha256-eaQmM5bfsUmzTiUALX543VBQRJK+TqW2i28npwSrn3Q=";

  subPackages = [ "cmd/lncli" "cmd/lnd" ];

  inherit tags;

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 prusnak ];
  };
}
