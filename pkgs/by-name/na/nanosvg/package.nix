{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2024-12-19";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "ea6a6aca009422bba0dbad4c80df6e6ba0c82183";
    hash = "sha256-QCjfaSm1/hstVGzkJc0gFnYhnU5I3oHSCTkAVG5gTt8=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/memononen/nanosvg";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
  };
}
