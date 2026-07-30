{
  fetchurl,
  lib,
  stdenv,
  cmake,
  ninja,
  poppler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "poppler-data";
  version = "0.4.12";

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-data-${finalAttrs.version}.tar.gz";
    sha256 = "yDW2QKQM41fhuDZmqr2V7f+iTd3dSbja/2OtuFHNq3Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = lib.platforms.all;
    license = lib.licenses.free; # more free licenses combined
    inherit (poppler.meta) teams maintainers;
  };
})
