{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-W3vPTLGI7YT7dFklJnOcpfYqQ9aBCsel9L6q4WNincY=";
  };

  vendorHash = "sha256-UVdOiaj1FN0etB9F0kt+THfO0Aa1kgdGYVeSVv4GpxY=";

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
