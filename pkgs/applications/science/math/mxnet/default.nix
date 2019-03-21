{ config, stdenv, lib, fetchurl, bash, cmake
, opencv, gtest, openblas, liblapack, perl
, cudaSupport ? config.cudaSupport or false, cudatoolkit, nvidia_x11
, cudnnSupport ? cudaSupport, cudnn
}:

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  name = "mxnet-${version}";
  version = "1.2.1";

  # Fetching from git does not work at the time (1.2.1) due to an
  # incorrect hash in one of the submodules. The provided tarballs
  # contain all necessary sources.
  src = fetchurl {
    url = "https://github.com/apache/incubator-mxnet/releases/download/${version}/apache-mxnet-src-${version}-incubating.tar.gz";
    sha256 = "053zbdgs4j8l79ipdz461zc7wyfbfcflmi5bw7lj2q08zm1glnb2";
  };

  nativeBuildInputs = [ cmake perl ];

  buildInputs = [ opencv gtest openblas liblapack ]
              ++ lib.optionals cudaSupport [ cudatoolkit nvidia_x11 ]
              ++ lib.optional cudnnSupport cudnn;

  cmakeFlags =
    (if cudaSupport then [
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = https://mxnet.incubator.apache.org/;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
