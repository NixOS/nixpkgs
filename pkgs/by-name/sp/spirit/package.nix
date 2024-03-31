{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "spirit";
  version = "0-unstable-2024-03-20";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "10e4bba0a89ef3b372046dc367c2b2d12e9d0c0b";
    hash = "sha256-tw+gHSxIHKEsHaVuknylk4zWsTRKGVNci9WimDC9y1A=";
  };

  vendorHash = "sha256-r6iQs5kgOniHCN8KteQ17rPhQ/73Exuqlu6qWgKEIzs=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
