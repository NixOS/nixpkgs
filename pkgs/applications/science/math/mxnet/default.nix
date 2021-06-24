{ config, stdenv, lib, fetchurl, bash, cmake
, opencv3, gtest, blas, perl
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

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ opencv3 gtest blas.provider ]
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
    platforms = platforms.linux;
  };
}
