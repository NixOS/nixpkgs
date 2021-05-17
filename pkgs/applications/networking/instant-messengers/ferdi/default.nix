{ lib, mkFranzDerivation, fetchurl }:

mkFranzDerivation rec {
  pname = "ferdi";
  name = "Ferdi";
  version = "5.6.0-beta.5";
  src = fetchurl {
    url = "https://github.com/getferdi/ferdi/releases/download/v${version}/ferdi_${version}_amd64.deb";
    sha256 = "sha256-fDUzYir53OQ3O4o9eG70sGD+FJ0/4SDNsTfh97WFRnQ=";
  };
  meta = with lib; {
    description = "Combine your favorite messaging services into one application";
    homepage = "https://getferdi.com/";
    license = licenses.asl20;
    maintainers = [ maintainers.davidtwco ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
