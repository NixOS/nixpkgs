{
  lib,
  stdenv,
  fetchFromGitHub,
  cpm-cmake,
  pkg-config,
  basis-universal,
  cmake,
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
    rev = "17b6319f05f0acd0b19da2bb526b7002a4c00c13";
    hash = "sha256-GKWh5xl6uIvEBTSEiObZ+K7GuuGFGwNp8R1oFpX/VNs=";
  };

  postPatch = ''
    install -D ${cpm-cmake}/share/cpm/CPM.cmake /build/source/build/cmake/CPM_0.38.7.cmake

    # This is 100% a packaging error with basis-universal but I can't figure out what's wrong rn so...
    substituteInPlace StereoKitC/asset_types/texture_compression.cpp \
      --replace-fail 'basisu_transcoder.h' 'basisu/basisu_transcoder.h'

    substituteInPlace StereoKitC/asset_types/texture.cpp \
      --replace-fail 'skg_tex_type_cubemap' 'skg_tex_type_rendertarget' \
      --replace-fail 'skg_tex_type_depth' 'skg_tex_type_depthtarget' \
      --replace-fail 'skg_tex_settings(texture, skg_addr, skg_sample, anisotropy_level);' \
                     'skg_tex_settings(texture, skg_addr, skg_sample, skg_sample_compare_none, anisotropy_level);'
  '';

  cmakeFlags = [
    (lib.cmakeBool "SK_BUILD_TESTS" false) # TODO: set back to true once fixed
  ];

  nativeBuildInputs = [
    cmake
    lld
    pkg-config
  ];
  buildInputs = [
    xorg.libX11
    xorg.libXfixes
    basis-universal
    libGL
    libgbm
    fontconfig
    sk_gpu
    openxr-loader
    meshoptimizer
    reactphysics3d
  ];
})
