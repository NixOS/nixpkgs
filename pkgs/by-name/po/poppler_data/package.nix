{
  fetchurl,
  lib,
  stdenv,
  cmake,
  ninja,
  poppler,
}:

stdenv.mkDerivation rec {
  pname = "poppler-data";
  version = "0.4.12";

  src = fetchurl {
    url = "https://poppler.freedesktop.org/${pname}-${version}.tar.gz";
    sha256 = "yDW2QKQM41fhuDZmqr2V7f+iTd3dSbja/2OtuFHNq3Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = lib.platforms.all;
    license = lib.licenses.free; # more free licenses combined
=======
  meta = with lib; {
    homepage = "https://poppler.freedesktop.org/";
    description = "Encoding files for Poppler, a PDF rendering library";
    platforms = platforms.all;
    license = licenses.free; # more free licenses combined
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (poppler.meta) teams maintainers;
  };
}
