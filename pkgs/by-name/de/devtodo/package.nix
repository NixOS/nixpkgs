{
  lib,
  stdenv,
  fetchurl,
  readline,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "devtodo";
  version = "0.1.20";

  src = fetchurl {
    url = "https://swapoff.org/files/devtodo/devtodo-${finalAttrs.version}.tar.gz";
    sha256 = "029y173njydzlznxmdizrrz4wcky47vqhl87fsb7xjcz9726m71p";
  };

  buildInputs = [
    readline
    ncurses
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://swapoff.org/devtodo1.html";
    description = "Hierarchical command-line task manager";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.woffs ];
    platforms = lib.platforms.linux;
  };
})
