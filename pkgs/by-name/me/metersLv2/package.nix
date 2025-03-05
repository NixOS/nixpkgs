{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, lv2
, libGLU
, libGL
, gtk2
, cairo
, pango
, fftwFloat
, libjack2
}:

stdenv.mkDerivation rec {
  pname = "meters.lv2";
  version = "0.9.20";
  robtkVersion = "0.7.5";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lv2 libGLU libGL gtk2 cairo pango fftwFloat libjack2 ];

  src = fetchFromGitHub {
    owner = "x42";
    repo = "meters.lv2";
    rev = "v${version}";
    sha256 = "sha256-eGXTbE83bJEDqTBltL6ZX9qa/OotCFmUxpE/aLqGELU=";
  };

  robtkSrc = fetchFromGitHub {
    owner = "x42";
    repo = "robtk";
    rev = "v${robtkVersion}";
    sha256 = "sha256-L1meipOco8esZl+Pgqgi/oYVbhimgh9n8p9Iqj3dZr0=";
  };

  postUnpack = ''
    rm -rf $sourceRoot/robtk/
    ln -s ${robtkSrc} $sourceRoot/robtk
  '';

  postPatch = ''
    substituteInPlace Makefile --replace "-msse -msse2 -mfpmath=sse" ""
  ''; # remove x86-specific flags

  meter_VERSION = version;
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "Collection of audio level meters with GUI in LV2 plugin format";
    mainProgram = "x42-meter";
    homepage = "https://x42.github.io/meters.lv2/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
