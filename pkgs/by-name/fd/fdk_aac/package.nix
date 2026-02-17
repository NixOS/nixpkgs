{
  lib,
  stdenv,
  fetchurl,
  exampleSupport ? false, # Example encoding program
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fdk-aac";
  version = "2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/fdk-aac/fdk-aac-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-gptrie7zgkCc2mhX/YKvhPq7Y0F7CO3p6npVP4Ect54=";
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
    maintainers = with lib.maintainers; [ codyopel ];
    platforms = lib.platforms.all;
  };
})
