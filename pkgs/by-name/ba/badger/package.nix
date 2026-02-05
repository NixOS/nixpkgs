{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-AmDfG4IOpptdH0/Un4V275UTTUXoV1LNKtbSj3O50rs=";
  };

  vendorHash = "sha256-+rXXCVH2xuULPzdM0KVPwYht+tu0qyxPjLLaBMWVIuI=";

  subPackages = [ "badger" ];

  doCheck = false;

  meta = {
    description = "Fast key-value DB in Go";
    homepage = "https://github.com/dgraph-io/badger";
    license = lib.licenses.asl20;
    mainProgram = "badger";
    maintainers = with lib.maintainers; [ farcaller ];
  };
}
