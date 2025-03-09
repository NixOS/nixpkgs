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

let
  stdenv' = if stdenv.hostPlatform.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "openimagedenoise";
  version = "2.2.2";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${finalAttrs.version}/oidn-${finalAttrs.version}.src.tar.gz";
    sha256 = "sha256-ZIrs4oEb+PzdMh2x2BUFXKyu/HBlFb3CJX24ciEHy3Q=";
  };

  patches = lib.optional cudaSupport ./cuda.patch;

  postPatch = ''
    substituteInPlace devices/metal/CMakeLists.txt \
      --replace-fail "AppleClang" "Clang"
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
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
    changelog = "https://github.com/OpenImageDenoise/oidn/blob/v${version}/CHANGELOG.md";
  };
})
