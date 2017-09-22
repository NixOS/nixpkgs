{ stdenv, lib, fetchgit, cmake
, opencv, gtest, openblas, liblapack
, cudaSupport ? false, cudatoolkit
, cudnnSupport ? false, cudnn
}:

assert cudnnSupport -> cudaSupport;

stdenv.mkDerivation rec {
  name = "mxnet-${version}";
  version = "0.11.0";

  # Submodules needed
  src = fetchgit {
    url = "https://github.com/apache/incubator-mxnet";
    rev = "refs/tags/${version}";
    sha256 = "1qgns0c70a1gfyil96h17ms736nwdkp9kv496gvs9pkzqzvr6cpz";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ opencv gtest openblas liblapack ]
              ++ lib.optional cudaSupport cudatoolkit
              ++ lib.optional cudnnSupport cudnn;

  cmakeFlags = lib.optional (!cudaSupport) "-DUSE_CUDA=OFF"
            ++ lib.optional (!cudnnSupport) "-DUSE_CUDNN=OFF";

  installPhase = ''
    install -Dm755 libmxnet.so $out/lib/libmxnet.so
    cp -r ../include $out
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Lightweight, Portable, Flexible Distributed/Mobile Deep Learning with Dynamic, Mutation-aware Dataflow Dep Scheduler";
    homepage = "https://mxnet.incubator.apache.org/";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
