{
  lib,
  stdenv,
  fetchurl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spot-automata";
  version = "2.15.1";

  src = fetchurl {
    url = "https://www.lrde.epita.fr/dload/spot/spot-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZQE6Lt8/MUhU12GYiBRfUsjdNr/SeJTZ25snLZoWzks=";
  };

  nativeBuildInputs = [ python3 ];

  configureFlags = [
    "--enable-c++20"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "C++/Python LTL and ω-automata manipulation library and tools";
    homepage = "https://spot.lre.epita.fr/";
    maintainers = [ lib.maintainers.astrobeastie ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
