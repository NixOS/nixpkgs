{
  stdenv,
  lib,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libvori";
  version = "220621";

  src = fetchurl {
    url = "https://brehm-research.de/files/${pname}-${version}.tar.gz";
    hash = "sha256-HPqYxWSBS92s8cDn8RWCE311hmj2MH5us5LHIxeYTBQ=";
  };

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
  meta = {
    description = "Library for Voronoi integration of electron densities";
    homepage = "https://brehm-research.de/libvori.php";
    license = with lib.licenses; [ lgpl3Only ];
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sheepforce ];
=======
  meta = with lib; {
    description = "Library for Voronoi integration of electron densities";
    homepage = "https://brehm-research.de/libvori.php";
    license = with licenses; [ lgpl3Only ];
    platforms = platforms.unix;
    maintainers = [ maintainers.sheepforce ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
