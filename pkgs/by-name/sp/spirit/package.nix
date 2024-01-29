{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "spirit";
  version = "0-unstable-2024-01-11";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "fdbfa0baf31e9406227ae7fa9403c977189d715c";
    hash = "sha256-kvERTUYVsuKS24/CavmlZd0K6hlosGMDLeEZcHfwBZI=";
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
