{ stdenv, fetchurl
, intltool, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  
  name = "galculator-${version}";
  version = "2.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/galculator/${name}.tar.gz";
    sha256 = "12m7dldjk10lpkdxk7zpk98n32ci65zmxidghihb7n1m3rhp3q17";
  };

  buildInputs = [ intltool pkgconfig gtk ];

  meta = with stdenv.lib; {
    description = "A GTK 2/3 algebraic and RPN calculator";
    longDescription = ''
      galculator is a GTK 2 / GTK 3 based calculator. Its main features include:

      - Algebraic, RPN (Reverse Polish Notation), Formula Entry and Paper modes;
      - Basic and Scientific Modes
      - Decimal, hexadecimal, octal and binary number base
      - Radiant, degree and grad support
      - User defined constants and functions
      - A bunch of common functions
      - Binary arithmetic of configurable bit length and signedness
      - Quad-precision floating point arithmetic, and 112-bit binary arithmetic
    '';
    homepage = http://galculator.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
