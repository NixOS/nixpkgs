{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "nanosvg";
  version = "0-unstable-2025-11-21";

  src = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "5cefd9847949af6df13f65027fd43af5a7513633";
    hash = "sha256-BozXqp3pNxAew+aFUbh6M3ppVQ+U7XMmMCbGT1urfWE=";
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
