{
  lib,
  stdenv,
  fetchurl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spot-automata";
  version = "2.14.2";

  src = fetchurl {
    url = "https://www.lrde.epita.fr/dload/spot/spot-${finalAttrs.version}.tar.gz";
    hash = "sha256-pRQqqbE7NiPNnB8JtIVUL4zeo+Ci/GEW7qNusPwZrxk=";
  };

  buildInputs = [ python3 ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--enable-c++20"
  ];

  meta = {
    description = "C++/Python LTL and ω-automata manipulation library and tools";
    homepage = "https://spot.lre.epita.fr/";
    maintainers = [ lib.maintainers.astrobeastie ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
