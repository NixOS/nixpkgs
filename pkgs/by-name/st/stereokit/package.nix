{
  lib,
  stdenv,
  fetchFromGitHub,
  cpm-cmake,
  pkg-config,
  cmake,
  ninja,
  clang,
  lld,
  libGL,
  libgbm,
  fontconfig,
  xorg,
  sk_gpu,
  meshoptimizer,
  openxr-loader,
  reactphysics3d,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stereokit";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "StereoKit";
    repo = "StereoKit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3WKs6eyYP2lOOKeQCBuRZLXZfO2l0iss0DsiLtHTkyg=";
  };

  postPatch = ''
    install -D ${cpm-cmake}/share/cpm/CPM.cmake /build/source/build/cmake/CPM_0.38.7.cmake
  '';

  patches = [
    ./system-packages.patch
  ];

  cmakeFlags = [
    # (lib.cmakeFeature "CPM_DOWNLOAD_LOCATION" "${cpm-cmake}/share/cpm/CPM.cmake")
  ];

  nativeBuildInputs = [
    cmake
    ninja
    clang
    lld
    pkg-config
  ];
  buildInputs = [
    xorg.libX11
    xorg.libXfixes
    libGL
    libgbm
    fontconfig
    sk_gpu
    openxr-loader
    meshoptimizer
    reactphysics3d
  ];
})
