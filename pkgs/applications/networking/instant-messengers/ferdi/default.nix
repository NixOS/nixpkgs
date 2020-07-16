{ stdenv, mkFranzDerivation, fetchurl }:

mkFranzDerivation rec {
  pname = "ferdi";
  name = "Ferdi";
  version = "5.5.0";
  src = fetchurl {
    url = "https://github.com/getferdi/ferdi/releases/download/v${version}/ferdi_${version}_amd64.deb";
    sha256 = "0i24vcnq4iz5amqmn2fgk92ff9x9y7fg8jhc3g6ksvmcfly7af3k";
  };
  meta = with stdenv.lib; {
    description = "Ferdi allows you to combine your favorite messaging services into one application";
    homepage = "https://getferdi.com/";
    license = licenses.free;
    maintainers = [ maintainers.davidtwco ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
