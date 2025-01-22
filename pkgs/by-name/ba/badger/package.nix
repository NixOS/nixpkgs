{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-95D67Q63AZTFRN9uj7HyF5QEjluYCYiDFGBJwgfK+mo=";
  };

  vendorHash = "sha256-8mfB8sKA5a6jV0/OA947mp+TPhdymsVzB2i9MIdg1WQ=";

  subPackages = [ "badger" ];

  doCheck = false;

  meta = with lib; {
    description = "Fast key-value DB in Go";
    homepage = "https://github.com/dgraph-io/badger";
    license = licenses.asl20;
    mainProgram = "badger";
    maintainers = with maintainers; [ farcaller ];
  };
}
