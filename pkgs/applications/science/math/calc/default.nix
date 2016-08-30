{ stdenv, fetchurl, makeWrapper, glibc, readline, ncurses, groff, utillinux }:

with stdenv.lib;
let
  makeFlags = ''
    INCDIR=${glibc.dev}/include \
    BINDIR=$out/bin LIBDIR=$out/lib CALC_INCDIR=$out/include/calc CALC_SHAREDIR=$out/share/calc MANDIR=$out/share/man/man1 \
    USE_READLINE=-DUSE_READLINE READLINE_LIB=-lreadline READLINE_EXTRAS='-lhistory -lncurses' \
    TERMCONTROL=-DUSE_TERMIOS \
    NROFF=groff
  '';
in
stdenv.mkDerivation rec {

  name = "calc-${version}";
  version = "2.12.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/calc/${name}.tar.bz2";
    sha256 = "14mnz6smhi3a0rgmwvddk9w3vdisi8khq67i8nqsl47vgs8n1kqg";
  };

  buildInputs = [ makeWrapper readline ncurses groff utillinux ];

  configurePhase = ''
    sed -i 's/all: check_include/all:/' Makefile
  '';

  buildPhase = ''
    make ${makeFlags}
  '';

  installPhase = ''
    make install ${makeFlags}
    wrapProgram $out/bin/calc --prefix LD_LIBRARY_PATH : $out/lib
  '';

  meta = {
    description = "C-style arbitrary precision calculator";
    homepage = http://www.isthe.com/chongo/tech/comp/calc/;
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
