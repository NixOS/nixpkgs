{
  lib,
  stdenv,
  autoreconfHook,
  buildPackages,
  fetchurl,
  flex,
  lzip,
  readline,
  ed,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bc";
  version = "1.08.2";
  src = fetchurl {
    url = "mirror://gnu/bc/bc-${finalAttrs.version}.tar.lz";
    hash = "sha256-eeMeAiqEsx3YCYFQY9S46lkLQJY3pSxQ7J9Cwr8zJxE=";
  };

  configureFlags = [ "--with-readline" ];

  # As of 1.07 cross-compilation is quite complicated as the build system wants
  # to build a code generator, bc/fbc, on the build machine.
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    # Tools
    autoreconfHook
    ed
    flex
    lzip
    texinfo
    # Libraries for build
    buildPackages.readline
    buildPackages.ncurses
  ];
  buildInputs = [
    readline
    flex
  ];

  doCheck = true; # not cross

  # Hack to make sure we never to the relaxation `$PATH` and hooks support for
  # compatibility. This will be replaced with something clearer in a future
  # masss-rebuild.
  strictDeps = true;

  meta = {
    description = "GNU software calculator";
    homepage = "https://www.gnu.org/software/bc/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "bc";
  };
})
