{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "spirit";
  version = "0-unstable-2024-04-18";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "886ee21e7338faef6612495b27d409713a202082";
    hash = "sha256-xXObprJCo9evArCX5ezqrD+lagiHMO4SwycY+pTkHPg=";
  };

  vendorHash = "sha256-r6iQs5kgOniHCN8KteQ17rPhQ/73Exuqlu6qWgKEIzs=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
