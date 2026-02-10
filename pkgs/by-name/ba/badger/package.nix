{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "badger";
  version = "4.9.1";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BsKFi4oMNJE09PBjFmqNhbMcQcHk5uR5QssbwN2ZNCk=";
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
})
