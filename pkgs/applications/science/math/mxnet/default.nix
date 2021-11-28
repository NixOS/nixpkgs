{ config, stdenv, lib, fetchurl, fetchpatch, bash, cmake
, opencv3, gtest, blas, gomp, llvmPackages, perl
, cudaSupport ? config.cudaSupport or false, cudatoolkit, nvidia_x11
, cudnnSupport ? cudaSupport, cudnn
}:

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  pname = "mxnet";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/apache/incubator-mxnet/releases/download/${version}/apache-mxnet-src-${version}-incubating.tar.gz";
    sha256 = "1vvdb7pfh63kb9fzs6gqp95q550a3ck4cj9mqxlk9wwhkh30dsq1";
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
    ++ lib.optionals cudaSupport [ cudatoolkit nvidia_x11 ]
    ++ lib.optional cudnnSupport cudnn;

  cmakeFlags =
    [ "-DUSE_MKL_IF_AVAILABLE=OFF" ]
    ++ (if cudaSupport then [
      "-DUSE_OLDCMAKECUDA=ON"  # see https://github.com/apache/incubator-mxnet/issues/10743
      "-DCUDA_ARCH_NAME=All"
      "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
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

  meta = with lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = "https://mxnet.incubator.apache.org/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
