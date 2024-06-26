{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "limesctl";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UYQe2C50tB1uc5ij8oh+RBaFg9UYWwPmJ77LCJ11Ml4=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "limesctl";
  };
}
