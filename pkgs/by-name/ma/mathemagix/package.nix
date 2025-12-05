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
  version = "11229";

  src = fetchsvn {
    url = "https://subversion.renater.fr/anonscm/svn/mmx/";
    rev = finalAttrs.version;
    hash = "sha256-JSjgvbOjV/66wjFpLGI1vCTvNGdYX48JTGGvWdBzQm8=";
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
    description = "Free computer algebra and analysis system consisting of a high level language with a compiler and a series of mathematical libraries";
    homepage = "https://www.mathemagix.org/";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
