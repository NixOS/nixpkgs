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
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  nvidia_x11,
  cudnnSupport ? cudaSupport,
}:

let
  inherit (cudaPackages)
    backendStdenv
    cudatoolkit
    cudaFlags
    cudnn
    ;
in

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  pname = "mxnet";
  version = "1.9.1";

  src = fetchurl {
    name = "apache-mxnet-src-${version}-incubating.tar.gz";
    url = "https://dlcdn.apache.org/incubator/mxnet/${version}/apache-mxnet-src-${version}-incubating.tar.gz";
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

  buildInputs =
    [
      opencv4
      gtest
      blas.provider
    ]
    ++ lib.optional stdenv.cc.isGNU gomp
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
    # FIXME: when cuda build is fixed, remove nvidia_x11, and use /run/opengl-driver/lib
    ++ lib.optionals cudaSupport [
      cudatoolkit
      nvidia_x11
    ]
    ++ lib.optional cudnnSupport cudnn;

  cmakeFlags =
    [ "-DUSE_MKL_IF_AVAILABLE=OFF" ]
    ++ (
      if cudaSupport then
        [
          "-DUSE_OLDCMAKECUDA=ON" # see https://github.com/apache/incubator-mxnet/issues/10743
          "-DCUDA_ARCH_NAME=All"
          "-DCUDA_HOST_COMPILER=${backendStdenv.cc}/bin/cc"
          "-DMXNET_CUDA_ARCH=${builtins.concatStringsSep ";" cudaFlags.realArches}"
        ]
      else
        [ "-DUSE_CUDA=OFF" ]
    )
    ++ lib.optional (!cudnnSupport) "-DUSE_CUDNN=OFF";

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

  # used to mark cudaSupport in python310Packages.mxnet as broken;
  # other attributes exposed for consistency
  passthru = {
    inherit
      cudaSupport
      cudnnSupport
      cudatoolkit
      cudnn
      ;
  };

  meta = with lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = "https://mxnet.incubator.apache.org/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.unix;
    # Build failures when linking mxnet_unit_tests: https://gist.github.com/6d17447ee3557967ec52c50d93b17a1d
    broken = cudaSupport;
  };
}
