{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-kjMLJAEZN+WANgXsQT7XYLEsc+IL9QwBmaNeD3kyjGw=";
  };

  vendorHash = "sha256-m4Bv8RhaUzqyzQ78/Ktr+wLRwL4mlXEsisW4pOJw1DI=";

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
