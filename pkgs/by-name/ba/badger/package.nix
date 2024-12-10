{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "badger";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-2d+OnSEERWx2JNYawbnuorBl6uIIoi2oO5n7uCsUzFo=";
  };

  vendorHash = "sha256-iaTR7V8l66BEadAiCftUZy7Gr+fdLRNnvBbtwdU/m/k=";

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
