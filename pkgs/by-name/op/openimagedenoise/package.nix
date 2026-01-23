{
  cmake,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  fetchzip,
  ispc,
  lib,
  python3,
  stdenv,
  onetbb,
  xcodebuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openimagedenoise";
  version = "2.3.3";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/RenderKit/oidn/releases/download/v${finalAttrs.version}/oidn-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-JzAd47fYGLT6DeOep8Wag29VY9HOTpqf0OSv1v0kGQU=";
  };

  patches = lib.optional cudaSupport ./cuda.patch;

  postPatch = ''
    # fix build failure with GCC14
    substituteInPlace cmake/oidn_platform.cmake \
      --replace-fail "set(CMAKE_CXX_STANDARD 11)" "set(CMAKE_CXX_STANDARD 14)"
  '';

  nativeBuildInputs = [
    cmake
    python3
    ispc
  ]
  ++ lib.optional cudaSupport cudaPackages.cuda_nvcc
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  buildInputs = [
    onetbb
  ]

  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl
  ];

  cmakeFlags = [
    (lib.cmakeBool "OIDN_DEVICE_CUDA" cudaSupport)
    (lib.cmakeFeature "TBB_INCLUDE_DIR" "${onetbb.dev}/include")
    (lib.cmakeFeature "TBB_ROOT" "${onetbb}")
  ];

  meta = {
    homepage = "https://www.openimagedenoise.org";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.leshainc ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/RenderKit/oidn/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
