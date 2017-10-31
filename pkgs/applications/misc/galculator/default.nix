{ stdenv, fetchFromGitHub
, autoreconfHook, intltool
, gtk, pkgconfig, flex }:

stdenv.mkDerivation rec {
  name = "galculator-${version}";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "galculator";
    repo = "galculator";
    rev = "v${version}";
    sha256 = "0q0hb62f266709ncyq96bpx4a40a1i6dc5869byvd7x285sx1c2w";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig ];
  buildInputs = [ gtk flex ];

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
