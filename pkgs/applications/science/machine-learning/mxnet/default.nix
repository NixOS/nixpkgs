{ stdenv, lib, fetchgit, cmake
, opencv, gtest, openblas
, cudaSupport ? false, cudatoolkit, nvidia_x11
, cudnnSupport ? false, cudnn
, perl
}:

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  name = "mxnet-${version}";
  version = "1.2.0";

  # Submodules needed
  src = fetchgit {
    url = "https://github.com/apache/incubator-mxnet";
    rev = "refs/tags/${version}";
    sha256 = "07i0cfvhhh5aw1rgazq8n5ick2hfagafp55vj5l5dk8j0xk47lv5";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ opencv gtest openblas perl ]
              ++ lib.optionals cudaSupport [ cudatoolkit nvidia_x11 ]
              ++ lib.optional cudnnSupport cudnn;

  preBuild = ''
    substituteInPlace 3rdparty/mkldnn/tests/CMakeFiles/test_c_symbols-c.dir/build.make\
      --replace "/bin/bash" "${stdenv.shell}"
  '';

  cmakeFlags =
    ["-DUSE_LAPACK=ON"] ++
    (if cudaSupport then [
      "-DCUDA_ARCH_NAME=All"
      "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
    ] else [ "-DUSE_CUDA=OFF" ])
    ++ lib.optional (!cudnnSupport) "-DUSE_CUDNN=OFF";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = https://mxnet.incubator.apache.org/;
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
