{ config, stdenv, lib, fetchurl, bash, cmake
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
  version = "1.9.1";

  src = fetchurl {
    name = "apache-mxnet-src-${version}-incubating.tar.gz";
    url = "https://dlcdn.apache.org/incubator/mxnet/${version}/apache-mxnet-src-${version}-incubating.tar.gz";
    hash = "sha256-EephMoF02MKblvNBl34D3rC/Sww3rOZY+T442euMkyI=";
  };

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
