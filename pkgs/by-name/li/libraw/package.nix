{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  lcms2,
  pkg-config,

  # for passthru.tests
  deepin,
  freeimage,
  hdrmerge,
  imagemagick,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libraw";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "LibRaw";
    repo = "LibRaw";
    rev = version;
    hash = "sha256-QFyRQ0V7din/rnkRvEWf521kSzN7HwJ3kZiQ43PAmVI=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
    "doc"
  ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit imagemagick hdrmerge freeimage;
    inherit (deepin) deepin-image-viewer;
    inherit (python3.pkgs) rawkit;
  };

  meta = with lib; {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = with licenses; [
      cddl
      lgpl2Plus
    ];
    platforms = platforms.unix;
  };
}
