{
  lib,
  stdenv,
  fetchurl,
  expat,
  zlib,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readosm";
  version = "1.1.0a";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/readosm-${finalAttrs.version}.tar.gz";
    hash = "sha256-23wFHSVs7H7NTDd1q5vIINpaS/cv/U6fQLkR15dw8UU=";
  };

  nativeBuildInputs = [ validatePkgConfig ];

  buildInputs = [
    expat
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Open source library to extract valid data from within an Open Street Map input file";
    homepage = "https://www.gaia-gis.it/fossil/readosm";
    license = with lib.licenses; [
      mpl11
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
  };
})
