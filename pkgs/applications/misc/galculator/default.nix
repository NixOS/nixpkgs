{ lib, stdenv, fetchFromGitHub, fetchpatch
, autoreconfHook, intltool
, gtk, pkg-config, flex }:

stdenv.mkDerivation rec {
  pname = "galculator";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "galculator";
    repo = "galculator";
    rev = "v${version}";
    sha256 = "0q0hb62f266709ncyq96bpx4a40a1i6dc5869byvd7x285sx1c2w";
  };

  patches = [
    # Pul patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/galculator/galculator/pull/45
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/galculator/galculator/commit/501a9e3feeb2e56889c0ff98ab6d0ab20348ccd6.patch";
      sha256 = "08c9d2b49a1mizgk7v37dp8r96x389zc13mzv4dcy16x448lhp67";
    })
  ];

  nativeBuildInputs = [ autoreconfHook intltool pkg-config ];
  buildInputs = [ gtk flex ];

  meta = with lib; {
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
    homepage = "http://galculator.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
