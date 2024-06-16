{
  lib,
  stdenv,
  fetchurl,
  zlib,
  bzip2,
  cmake,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spades";
  version = "3.15.5";

  src = fetchurl {
    url = "https://github.com/ablab/spades/releases/download/v${finalAttrs.version}/SPAdes-${finalAttrs.version}.tar.gz";
    hash = "sha256-FVw2QNVx8uexmgUDHR/Q0ZvYLfeF04hw+5O9JBsSu/o=";
  };
  sourceRoot = "SPAdes-${finalAttrs.version}/src";

  env.CXXFLAGS = toString [
    # GCC 13: error: 'uint32_t' does not name a type
    "-include cstdint"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
    bzip2
    python3
  ];

  doCheck = true;

  meta = {
    description = "St. Petersburg genome assembler, a toolkit for assembling and analyzing sequencing data";
    license = lib.licenses.gpl2Only;
    homepage = "http://ablab.github.io/spades";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
