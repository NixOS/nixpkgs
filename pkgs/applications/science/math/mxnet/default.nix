{ config, stdenv, lib, fetchurl, fetchpatch, bash, cmake
, opencv3, gtest, blas, gomp, llvmPackages, perl
, cudaSupport ? config.cudaSupport or false, cudaPackages ? {}, nvidia_x11
, cudnnSupport ? cudaSupport
, cudaCapabilities ? [ "3.7" "5.0" "6.0" "7.0" "7.5" "8.0" "8.6" ]
}:

let
  inherit (cudaPackages) cudatoolkit cudnn;
in

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  pname = "mxnet";
  version = "1.8.0";

  src = fetchurl {
    name = "apache-mxnet-src-${version}-incubating.tar.gz";
    url = "https://dlcdn.apache.org/incubator/mxnet/${version}/apache-mxnet-src-${version}-incubating.tar.gz";
    hash = "sha256-la/5hYlaukCcCNVRRRCuOLiEkM+2KBqzpf8PWCbI21Q=";
  };

  patches = [
    # Fix build error https://github.com/apache/incubator-mxnet/issues/19405
    (fetchpatch {
      name = "mxnet-fix-gcc-linker-error-1.patch";
      url = "https://github.com/apache/incubator-mxnet/commit/78e31d66d19e385ca4ef73245ce79a47e375d8d1.diff";
      sha256 = "sha256-UfmGhh4RbvrEOXe6IJxHm1Aqpy1gS6gHxrX5KQBXjv4=";
    })
    (fetchpatch {
      name = "mxnet-fix-gcc-linker-error-2.patch";
      url = "https://github.com/apache/incubator-mxnet/commit/9bfe3116aabd01049fdbd90855cb245a30b795df.diff";
      sha256 = "sha256-BL7Zf7Bgn0qpai9HbQ6LBxZNa3iLjVJSe5nxZgqI/fw=";
    })
  ];

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ opencv3 gtest blas.provider ]
    ++ lib.optional stdenv.cc.isGNU gomp
    ++ lib.optional stdenv.cc.isClang llvmPackages.openmp
    # FIXME: when cuda build is fixed, remove nvidia_x11, and use /run/opengl-driver/lib
    ++ lib.optionals cudaSupport [ cudatoolkit nvidia_x11 ]
    ++ lib.optional cudnnSupport cudnn;

  cmakeFlags =
    [ "-DUSE_MKL_IF_AVAILABLE=OFF" ]
    ++ (if cudaSupport then [
      "-DUSE_OLDCMAKECUDA=ON"  # see https://github.com/apache/incubator-mxnet/issues/10743
      "-DCUDA_ARCH_NAME=All"
      "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
      "-DMXNET_CUDA_ARCH=${lib.concatStringsSep ";" cudaCapabilities}"
    ] else [ "-DUSE_CUDA=OFF" ])
    ++ lib.optional (!cudnnSupport) "-DUSE_CUDNN=OFF";

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
    inherit cudaSupport cudnnSupport cudatoolkit cudnn;
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
