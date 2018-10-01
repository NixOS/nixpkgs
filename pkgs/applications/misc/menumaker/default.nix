{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "menumaker-${version}";
  version = "0.99.10";

  src = fetchurl {
    url = "mirror://sourceforge/menumaker/${name}.tar.gz";
    sha256 = "1mm4cvg3kphkkd8nwrhcg6d9nm5ar7mgc0wf6fxk6zck1l7xn8ky";
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
