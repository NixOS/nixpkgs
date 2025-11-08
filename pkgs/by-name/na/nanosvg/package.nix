{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2025-09-28";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "66579081d84b613daa49a64f76357ce65925e13b";
    hash = "sha256-wdT0FIGSlfjDK1k95t17NIF2mEWLkJVAZL9TImehIUE=";
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
