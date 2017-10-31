{ stdenv, fetchurl, makeWrapper, glibc, readline, ncurses, utillinux }:

with stdenv.lib;
let
  makeFlags = ''
    INCDIR=${glibc.dev}/include \
    BINDIR=$out/bin LIBDIR=$out/lib CALC_INCDIR=$out/include/calc CALC_SHAREDIR=$out/share/calc MANDIR=$out/share/man/man1 \
    USE_READLINE=-DUSE_READLINE READLINE_LIB=-lreadline READLINE_EXTRAS='-lhistory -lncurses' \
    TERMCONTROL=-DUSE_TERMIOS \
  '';
in
stdenv.mkDerivation rec {

  name = "calc-${version}";
  version = "2.12.6.3";

  src = fetchurl {
    url = "https://github.com/lcn2/calc/releases/download/${version}/${name}.tar.bz2";
    sha256 = "01m20s5zs74zyb23x6zg6i13gc30a2ay2iz1rdbkxram01cblzky";
  };

  buildInputs = [ makeWrapper readline ncurses utillinux ];

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

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "C-style arbitrary precision calculator";
    homepage = http://www.isthe.com/chongo/tech/comp/calc/;
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
