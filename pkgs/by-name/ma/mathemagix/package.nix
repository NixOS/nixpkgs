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

stdenv.mkDerivation (finalAttrs: {
  pname = "mathemagix";
  version = "11126";

  src = fetchsvn {
    url = "https://subversion.renater.fr/anonscm/svn/mmx/";
    rev = finalAttrs.version;
    hash = "sha256-AFnYd5oFg/wgaHPjfZmqXNljEpoFW4h6f3UG+KZauEs=";
  };

  strictDeps = true;

  buildInputs = [
    gmp
    libtool
    mpfr
    ncurses
    readline
  ];

  nativeBuildInputs = [
    bison
  ];

  preConfigure = ''
    export HOME="$PWD"
  '';

  meta = {
    description = "A free computer algebra and analysis system consisting of a high level language with a compiler and a series of mathematical libraries";
    homepage = "http://www.mathemagix.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.linux;
  };
})
