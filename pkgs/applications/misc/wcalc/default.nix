{ stdenv, fetchurl, mpfr, readline }:

stdenv.mkDerivation rec {
  name = "wcalc-${version}";
  version = "2.5";

  src = fetchurl {
    url = "mirror://sourceforge/w-calc/${name}.tar.bz2";
    sha256 = "1vi8dl6rccqiq1apmpwawyg2ywx6a1ic1d3cvkf2hlwk1z11fb0f";
  };

  buildInputs = [ mpfr readline ];

  meta = with stdenv.lib; {
    description = "A command line calculator";
    homepage = http://w-calc.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}
