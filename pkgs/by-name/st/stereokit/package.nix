{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  clang,
  lld,
  libGL,
  libgbm,
  fontconfig,
  xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stereokit";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "StereoKit";
    repo = "StereoKit";
    tag = "v${finalAttrs.version}";
  };

  nativeBuildInputs = [
    cmake
    ninja
    clang
    lld
  ];
  buildInputs = [
    xorg.libX11
    xorg.libXfixes
    libGL
    libgbm
    fontconfig
  ];
})
