{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maxflow";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "gerddie";
    repo = "maxflow";
    rev = finalAttrs.version;
    hash = "sha256-a84SxGMnfBEaoMEeeIFffTOtErSN5yzZBrAUDjkalGY=";
  };

  patches = [
    # https://github.com/gerddie/maxflow/pull/7
    ./0001-Raise-minimum-CMake-version.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Software for computing mincut/maxflow in a graph";
    homepage = "https://github.com/gerddie/maxflow";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.tadfisher ];
  };
})
