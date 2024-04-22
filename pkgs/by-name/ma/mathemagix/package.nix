{
  stdenv,
  lib,
  fetchsvn,
  readline,
  ncurses,
  bison,
  libtool,
  gmp,
  mpfr,
}:

stdenv.mkDerivation {
  pname = "mathemagix";
  version = "11126";

  src = fetchsvn {
    url = "https://subversion.renater.fr/anonscm/svn/mmx/";
    rev = 11126;
    hash = "sha256-AFnYd5oFg/wgaHPjfZmqXNljEpoFW4h6f3UG+KZauEs=";
  };

  nativeBuildInputs = [
    readline
    ncurses
    bison
    libtool
    gmp
    mpfr
  ];

  preConfigure = ''
    export HOME="$PWD"
  '';

  configureFlags = [ "--prefix=${placeholder "out"}" ];

  meta = {
    description = "Mathemagix is a free computer algebra and analysis system. It consists of a high level language with a compiler and a series of mathematical libraries, some of which are written in C++.";
    homepage = "http://www.mathemagix.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
}
