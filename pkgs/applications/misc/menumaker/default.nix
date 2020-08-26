{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "menumaker";
  version = "0.99.12";

  src = fetchurl {
    url = "mirror://sourceforge/menumaker/${pname}-${version}.tar.gz";
    sha256 = "034v5204bsgkzzk6zfa5ia63q95gln47f7hwf96yvad5hrhmd8z3";
  };

  format = "other";

  meta = with stdenv.lib; {
    description = "Heuristics-driven menu generator for several window managers";
    homepage = "http://menumaker.sourceforge.net";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
