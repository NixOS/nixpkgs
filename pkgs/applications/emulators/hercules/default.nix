{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "hercules";
  version = "3.13";

  src = fetchurl {
    url = "http://downloads.hercules-390.eu/${pname}-${version}.tar.gz";
    sha256 = "0zg6rwz8ib4alibf8lygi8qn69xx8n92kbi8b3jhi1ymb32mf349";
  };

  meta = with lib; {
    homepage = "http://www.hercules-390.eu";
    description = "IBM mainframe emulator";
    longDescription = ''
      Hercules is an open source software implementation of the mainframe
      System/370 and ESA/390 architectures, in addition to the latest 64-bit
      z/Architecture. Hercules runs under Linux, Windows, Solaris, FreeBSD, and
      Mac OS X.
    '';
    license = licenses.qpl;
    maintainers = [ maintainers.anna328p ];
  };
}
