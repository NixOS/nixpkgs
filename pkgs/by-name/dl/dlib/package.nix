{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libpng,
  libjpeg,
  libwebp,
  blas,
  lapack,
  config,
  guiSupport ? false,
  libX11,
  enableShared ? !stdenv.hostPlatform.isStatic, # dlib has a build system that forces the user to choose between either shared or static libraries. See https://github.com/davisking/dlib/issues/923#issuecomment-2175865174
  sse4Support ? stdenv.hostPlatform.sse4_1Support,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}@inputs:
(if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv).mkDerivation rec {
  pname = "dlib";
  version = "20.0";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    tag = "v${version}";
    sha256 = "sha256-VTX7s0p2AzlvPUsSMXwZiij+UY9g2y+a1YIge9bi0sw=";
  };

  postPatch = ''
    rm -rf dlib/external
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "USE_SSE4_INSTRUCTIONS" sse4Support)
    (lib.cmakeBool "USE_AVX_INSTRUCTIONS" avxSupport)
    (lib.cmakeBool "DLIB_USE_CUDA" cudaSupport)
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    (lib.cmakeBool "USE_NEON_INSTRUCTIONS" false)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "DLIB_USE_CUDA_COMPUTE_CAPABILITIES" (
      builtins.concatStringsSep "," (with cudaPackages.flags; map dropDots cudaCapabilities)
    ))
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_nvcc
    ]
  );

  buildInputs = [
    libpng
    libjpeg
    libwebp
    blas
    lapack
  ]
  ++ lib.optionals guiSupport [ libX11 ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart
      cuda_nvcc
      libcublas
      libcurand
      libcusolver
      cudnn
      cuda_cccl
    ]
  );

  passthru = {
    inherit
      cudaSupport
      cudaPackages
      sse4Support
      avxSupport
      ;
  };

  meta = with lib; {
    description = "General purpose cross-platform C++ machine learning library";
    homepage = "http://www.dlib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = platforms.unix;
  };
}
