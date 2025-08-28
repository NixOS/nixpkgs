{
  lib,
  stdenv,
  fetchurl,
  flex,
  ncurses,
  readline,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgdb";
  version = "0.8.0";

  src = fetchurl {
    url = "https://cgdb.me/files/cgdb-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-DTi1JNN3JXsQa61thW2K4zBBQOHuJAhTQ+bd8bZYEfE=";
  };

  patches = [
    ./gcc14.patch
  ];

  buildInputs = [
    ncurses
    readline
  ];

  nativeBuildInputs = [
    flex
    texinfo
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Curses interface to gdb";
    mainProgram = "cgdb";

    homepage = "https://cgdb.github.io/";

    license = licenses.gpl2Plus;

    platforms = with platforms; linux ++ cygwin;
    maintainers = [ ];
  };
})
