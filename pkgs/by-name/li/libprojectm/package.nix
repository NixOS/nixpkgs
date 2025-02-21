{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGL,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libprojectm";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gf1k9iSDARp6/M2/Po1wdOEY6y/QG2nq5uhSFU6bxAM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libGL
    xorg.libX11
  ];

  strictDeps = true;

  meta = {
    description = "Cross-platform Milkdrop-compatible Music Visualization Library";
    homepage = "https://github.com/projectM-visualizer/projectm";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
    longDescription = ''
      The open-source project that reimplements the esteemed Winamp Milkdrop by
      Geiss in a more modern, cross-platform reusable library.
      Read an audio input and produces mesmerizing visuals, detecting tempo, and
      rendering advanced equations into a limitless array of user-contributed visualizations.
    '';
  };
})
