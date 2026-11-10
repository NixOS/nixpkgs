{
  lib,
  stdenv,
  fetchurl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spot-automata";
  version = "2.16.2";

  src = fetchurl {
    url = "https://www.lre.epita.fr/dload/spot/spot-${finalAttrs.version}.tar.gz";
    hash = "sha256-UvjQbPm/GuG0MJ7F00Ge9071wZm3HHCiNS5MTwojAqw=";
  };

  nativeBuildInputs = [ python3 ];

  configureFlags = [
    "--enable-c++20"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.pythonModule = python3;

  meta = {
    description = "C++/Python LTL and ω-automata manipulation library and tools";
    homepage = "https://spot.lre.epita.fr/";
    maintainers = [ lib.maintainers.astrobeastie ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
