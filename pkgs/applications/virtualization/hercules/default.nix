{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "hercules";
  version = "3.13";

  src = fetchurl {
    url = "http://downloads.hercules-390.eu/${pname}-${version}.tar.gz";
    sha256 = "0zg6rwz8ib4alibf8lygi8qn69xx8n92kbi8b3jhi1ymb32mf349";
  };

  meta = with lib; {
    description = "IBM mainframe emulator";
    homepage = "http://www.hercules-390.eu";
    license = licenses.qpl;
    maintainers = [ maintainers.anna328p ];
  };
}
