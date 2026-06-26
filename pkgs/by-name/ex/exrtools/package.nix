{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  openexr,
  libpng12,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exrtools";
  version = "0.4";

  src = fetchurl {
    url = "http://scanline.ca/exrtools/exrtools-${finalAttrs.version}.tar.gz";
    sha256 = "0jpkskqs1yjiighab4s91jy0c0qxcscwadfn94xy2mm2bx2qwp4z";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openexr
    libpng12
    libjpeg
  ];

  meta = {
    description = "Collection of utilities for manipulating OpenEXR images";
    homepage = "http://scanline.ca/exrtools";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.juliendehos ];
  };
})
