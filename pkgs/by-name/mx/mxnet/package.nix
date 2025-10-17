{
  config,
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  bash,
  cmake,
  opencv4,
  gtest,
  blas,
  gomp,
  llvmPackages,
  perl,
  # mxnet cuda support is turned off, but dependencies like opencv can still be built with cudaSupport
  # and fail to compile without the cudatoolkit
  # mxnet cuda support will not be available, as mxnet requires version <=11
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:

# mxnet is not maintained, and other projects are migrating away from it.
# https://github.com/apache/mxnet/issues/21206

stdenv.mkDerivation rec {
  pname = "mxnet";
  version = "1.9.1";

  src = fetchurl {
    name = "apache-mxnet-src-${version}-incubating.tar.gz";
    url = "mirror://apache/incubator/mxnet/${version}/apache-mxnet-src-${version}-incubating.tar.gz";
    hash = "sha256-EephMoF02MKblvNBl34D3rC/Sww3rOZY+T442euMkyI=";
  };

  patches = [
    # Remove the following two patches when updating mxnet to 2.0.
    (fetchpatch {
      name = "1-auto-disable-sse-for-non-x86.patch";
      url = "https://github.com/apache/incubator-mxnet/commit/55e69871d4cadec51a8bbb6700131065388cb0b9.patch";
      hash = "sha256-uaMpM0F9HRtEBXz2ewB/dlbuKaY5/RineCPUE2T6CHU=";
    })
    (fetchpatch {
      name = "2-auto-disable-sse-for-non-x86.patch";
      url = "https://github.com/apache/incubator-mxnet/commit/c1b96f562f55dfa024ac941d7b104f00e239ee0f.patch";
      excludes = [ "ci/docker/runtime_functions.sh" ];
      hash = "sha256-r1LbC8ueRooW5tTNakAlRSJ+9aR4WXXoEKx895DgOs4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    perl
  ];

  buildInputs = [
    opencv4
    gtest
    blas.provider
  ]
  ++ lib.optional stdenv.cc.isGNU gomp
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
  ++ lib.optionals cudaSupport [
    # needed for OpenCV cmake module
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    "-DUSE_MKL_IF_AVAILABLE=OFF"
    "-DUSE_CUDA=OFF"
    "-DUSE_CUDNN=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=uninitialized"
  ];

  postPatch = ''
    substituteInPlace 3rdparty/mkldnn/tests/CMakeLists.txt \
      --replace "/bin/bash" "${bash}/bin/bash"

    # Build against the system version of OpenMP.
    # https://github.com/apache/incubator-mxnet/pull/12160
    rm -rf 3rdparty/openmp
  '';

  postInstall = ''
    rm "$out"/lib/*.a
  '';

  meta = with lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = "https://mxnet.incubator.apache.org/";
    maintainers = [ ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
