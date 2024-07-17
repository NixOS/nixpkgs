{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "badger";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "badger";
    rev = "v${version}";
    hash = "sha256-+b+VTGUGmqixB51f1U2QK+XfVra4zXybW19n/CeeoAQ=";
  };

  vendorHash = "sha256-YiSmxtRt8HtYcvPL9ZKMjb2ch/MZBjZp5pIIBdqQ7Nw=";

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
