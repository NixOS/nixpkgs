{ buildGoModule
, fetchFromGitHub
, lib
, tags ? [ "autopilotrpc" "signrpc" "walletrpc" "chainrpc" "invoicesrpc" "watchtowerrpc" "routerrpc" "monitoring" "kvdb_postgres" "kvdb_etcd" ]
}:

buildGoModule rec {
  pname = "lnd";
  version = "0.18.2-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    hash = "sha256-qqvLnJlFGeCizm6T9iUwvYLjWpAeZwbuzQlUUopwrjc=";
  };

  vendorHash = "sha256-BxNtZzwmKJ/kZk7ndtEUC4bMGpd8LEhFFu4Z49bKydE=";

  subPackages = [ "cmd/lncli" "cmd/lnd" ];

  inherit tags;

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 prusnak ];
  };
}
