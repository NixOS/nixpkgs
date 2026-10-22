{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "239e102ec2c691f2902e20ace2ed36ee4a35cfe6";
    hash = "sha256-Vc0cehgA39WSXFEekVva+0gEARz7QTFc1nK85IQf1KI=";
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
