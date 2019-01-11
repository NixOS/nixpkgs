{ stdenv, lib, fetchgit, bash, cmake
, opencv, gtest, openblas, liblapack, perl
, cudaSupport ? false, cudatoolkit, nvidia_x11
, cudnnSupport ? false, cudnn
}:

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  name = "mxnet-${version}";
  version = "1.3.1";

  src = fetchgit {
    url = "https://github.com/apache/incubator-mxnet";
    rev = "1.3.1";
    sha256 = "06vk4q7bh17sjhnr72bzmggcqlp2injnsah5yflklg360p7vpijj";
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

  NIX_CFLAGS_COMPILE = "-Wno-error=format-truncation";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = https://mxnet.incubator.apache.org/;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
