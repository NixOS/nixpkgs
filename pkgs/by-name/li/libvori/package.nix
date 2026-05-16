{
  stdenv,
  lib,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvori";
  version = "220621";

  src = fetchurl {
    url = "https://brehm-research.de/files/libvori-${finalAttrs.version}.tar.gz";
    hash = "sha256-HPqYxWSBS92s8cDn8RWCE311hmj2MH5us5LHIxeYTBQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Library for Voronoi integration of electron densities";
    homepage = "https://brehm-research.de/libvori.php";
    license = with lib.licenses; [ lgpl3Only ];
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
