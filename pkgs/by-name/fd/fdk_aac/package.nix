{
  lib,
  stdenv,
  fetchurl,
  exampleSupport ? false, # Example encoding program
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdk-aac";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/fdk-aac-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-cLlYV7lY+495RIkweoeEXd5MwfzqBg8/KfQOSy/hbII=";
  };

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  configureFlags = lib.optional exampleSupport "--enable-example";

  meta = {
    description = "High-quality implementation of the AAC codec from Android";
    homepage = "https://sourceforge.net/projects/opencore-amr/";
    license = lib.licenses.fraunhofer-fdk;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
