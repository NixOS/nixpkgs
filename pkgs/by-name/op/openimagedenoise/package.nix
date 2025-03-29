{
  cmake,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  darwin,
  fetchzip,
  ispc,
  lib,
  python3,
  stdenv,
  tbb,
  xcodebuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openimagedenoise";
  version = "2.3.2";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/RenderKit/oidn/releases/download/v${finalAttrs.version}/oidn-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-yTa6U/1idfidbfNTQ7mXcroe7M4eM7Frxi45A/7e2A8=";
  };

  patches = lib.optional cudaSupport ./cuda.patch;

  postPatch = ''
    # fix build failure with GCC14
    substituteInPlace cmake/oidn_platform.cmake \
      --replace-fail "set(CMAKE_CXX_STANDARD 11)" "set(CMAKE_CXX_STANDARD 14)"
  '';

  nativeBuildInputs =
    [
      cmake
      python3
      ispc
    ]
    ++ lib.optional cudaSupport cudaPackages.cuda_nvcc
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcodebuild ];

  buildInputs =
    [ tbb ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk_11_0.frameworks;
      [
        Accelerate
        MetalKit
        MetalPerformanceShadersGraph
      ]
    )
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
    ];

  cmakeFlags = [
    (lib.cmakeBool "OIDN_DEVICE_CUDA" cudaSupport)
    (lib.cmakeFeature "TBB_INCLUDE_DIR" "${tbb.dev}/include")
    (lib.cmakeFeature "TBB_ROOT" "${tbb}")
  ];

  meta = with lib; {
    homepage = "https://www.openimagedenoise.org";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
    changelog = "https://github.com/RenderKit/oidn/blob/v${version}/CHANGELOG.md";
  };
})
