{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  lv2,
  libGLU,
  libGL,
  gtk2,
  cairo,
  pango,
  fftwFloat,
  libjack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meters-lv2";
  version = "0.9.28";
  robtkVersion = "0.8.6";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    lv2
    libGLU
    libGL
    cairo
    pango
    fftwFloat
    libjack2
  ];

  src = fetchFromGitHub {
    owner = "x42";
    repo = "meters.lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vNLo16ZFBrbV5AYDGu9CIb+pXW7fAzc8IDDryuAeeLM=";
  };

  robtkSrc = fetchFromGitHub {
    owner = "x42";
    repo = "robtk";
    tag = "v${finalAttrs.robtkVersion}";
    hash = "sha256-/X7+oZh25IIbji6THwDGcP+SlGIPi/T4HnFtVx/PcZ0=";
  };

  postUnpack = ''
    rm -rf $sourceRoot/robtk/
    ln -s ${finalAttrs.robtkSrc} $sourceRoot/robtk
  '';

  postPatch = ''
    substituteInPlace Makefile --replace "-msse -msse2 -mfpmath=sse" ""
  ''; # remove x86-specific flags

  meter_VERSION = finalAttrs.version;
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Collection of audio level meters with GUI in LV2 plugin format";
    mainProgram = "x42-meter";
    homepage = "https://x42.github.io/meters.lv2/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
