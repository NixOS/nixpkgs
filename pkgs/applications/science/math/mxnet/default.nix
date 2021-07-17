{ config
, stdenv
, lib
, fetchFromGitHub
, cmake
, gtest
, opencv3
, blas
, perl
, cudaSupport ? config.cudaSupport or false
, cudatoolkit
, nvidia_x11
, cudnnSupport ? cudaSupport
, cudnn
}:

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  pname = "mxnet";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "incubator-mxnet";
    rev = version;
    sha256 = "sha256-/IwFMEOStqkptLrCpi6UiD0IOh/Cgz+7o4alqUXWIis=";
    fetchSubmodules = true;
  };

  # Build against the system version of OpenMP.
  postPatch = ''
    rm -rf 3rdparty/openmp
  '';

  nativeBuildInputs = [ cmake gtest perl ];

  buildInputs = [ opencv3 blas.provider ]
    ++ lib.optionals cudaSupport [ cudatoolkit nvidia_x11 ]
    ++ lib.optional cudnnSupport cudnn;

  cmakeFlags = [
    "-DUSE_MKL_IF_AVAILABLE=OFF"
  ]
  ++ (if cudaSupport then [
    "-DUSE_OLDCMAKECUDA=ON" # see https://github.com/apache/incubator-mxnet/issues/10743
    "-DCUDA_ARCH_NAME=All"
    "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
  ] else [ "-DUSE_CUDA=OFF" ])
  ++ lib.optional (!cudnnSupport) "-DUSE_CUDNN=OFF";

  postInstall = ''
    rm "$out"/lib/*.a
  '';

  meta = with lib; {
    description = ''
      Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with
      Dynamic, Mutation-aware Dataflow Dep Scheduler
    '';
    homepage = "https://mxnet.incubator.apache.org/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
