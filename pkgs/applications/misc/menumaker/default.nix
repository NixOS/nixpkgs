{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "menumaker";
  version = "0.99.11";

  src = fetchurl {
    url = "mirror://sourceforge/menumaker/${pname}-${version}.tar.gz";
    sha256 = "0dprndnhwm7b803zkp4pisiq06ic9iv8vr42in5is47jmvdim0wx";
  };

  format = "other";

  meta = with stdenv.lib; {
    description = "Heuristics-driven menu generator for several window managers";
    homepage = http://menumaker.sourceforge.net;
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
