{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2025-09-20";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "d55a1fe69b1c7f41cf555a7135d54761efb1e56b";
    hash = "sha256-OSOnBtXibFztJ8GLh+XFI6b7egcgkGFXfqI2V5tnDD0=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Simple stupid SVG parser";
    homepage = "https://github.com/memononen/nanosvg";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
