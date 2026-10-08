{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  tzdata,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.4.11";
  pname = "dateutils";

  src = fetchurl {
    url = "https://bitbucket.org/hroptatyr/dateutils/downloads/dateutils-${finalAttrs.version}.tar.xz";
    hash = "sha256-uP6gsJcUu63yArmzQ0zOa1nCgueGkmjQwIuFiA/btEY=";
  };

  patches = [
    # TODO: Remove when updating to the next release.
    (fetchpatch {
      url = "https://github.com/hroptatyr/dateutils/commit/b30902c2f46288b570c7fa8de06e17cc7dfd6a37.patch";
      hash = "sha256-38LBUv4FLpK3TTIXXvIGr0qE0CSqF2IqCbZY5RGyi6Q=";
    })
  ];

  # https://github.com/hroptatyr/dateutils/issues/148
  postPatch = "rm test/dzone.008.ctst";

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
  ];
  buildInputs = [ tzdata ]; # needed for datezone

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Command-line utilities for date and time calculations and conversions";
    homepage = "http://www.fresse.org/dateutils/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.paperdigits ];
  };
})
