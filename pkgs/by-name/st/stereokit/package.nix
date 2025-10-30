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
    rev = "2e200e1f8e1fed1d3cd0d0d98d92acd047cd22db";
    hash = "sha256-Rq809UOowY0TFyDrCv99YdTIgIoYVh8UKgB4adgU39Y=";
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
