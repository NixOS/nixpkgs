{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  libinput,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gebaar-libinput";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "Coffee2CodeNL";
    repo = "gebaar-libinput";
    tag = "v${finalAttrs.version}";
    sha256 = "1kqcgwkia1p195xr082838dvj1gqif9d63i8a52jb0lc32zzizh6";
    fetchSubmodules = true;
  };

  patches = [
    # fix build with gcc 11+
    (fetchpatch {
      url = "https://github.com/9ary/gebaar-libinput-fork/commit/25cac08a5f1aed1951b03de12fa0010a0964967d.patch";
      hash = "sha256-CtgfMTBCXotiPAXc7cA3h+7Kb0NHFi/q7w72IY32CyA=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    libinput
    zlib
  ];

  meta = {
    description = "Gebaar, A Super Simple WM Independent Touchpad Gesture Daemon for libinput";
    mainProgram = "gebaard";
    homepage = "https://github.com/Coffee2CodeNL/gebaar-libinput";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lovesegfault
    ];
  };
})
