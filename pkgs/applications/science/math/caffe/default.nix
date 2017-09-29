{ stdenv, lib
, fetchFromGitHub
, cmake
, boost
, google-gflags
, glog
, hdf5-cpp
, leveldb
, lmdb
, opencv
, protobuf
, snappy
, atlas
, doxygen
, cudaSupport ? true, cudatoolkit
, cudnnSupport ? false, cudnn ? null
, pythonSupport ? false, python ? null, numpy ? null
}:

assert cudnnSupport -> cudaSupport;
assert pythonSupport -> (python != null && numpy != null);

stdenv.mkDerivation rec {
  name = "caffe-${version}";
  version = "1.0-rc5";

  src = fetchFromGitHub {
    owner = "BVLC";
    repo = "caffe";
    rev = "rc5";
    sha256 = "0lfmmc0n6xvkpygvxclzrvd0zigb4yfc5612anv2ahlxpfi9031c";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake doxygen ];

  cmakeFlags = [ "-DCUDA_ARCH_NAME=All" ]
               ++ lib.optional (!cudaSupport) "-DCPU_ONLY=ON"
               ++ lib.optional (!pythonSupport) "-DBUILD_python=OFF";

  buildInputs = [ boost google-gflags glog protobuf hdf5-cpp lmdb leveldb snappy opencv atlas ]
                ++ lib.optional cudaSupport cudatoolkit
                ++ lib.optional cudnnSupport cudnn
                ++ lib.optionals pythonSupport [ python numpy ];

  propagatedBuildInputs = lib.optional pythonSupport python.pkgs.protobuf;

  outputs = [ "bin" "out"];
  propagatedBuildOutputs = []; # otherwise propagates out -> bin cycle

  postInstall = ''
    # Internal static library.
    rm $out/lib/libproto.a

    moveToOutput "bin" "$bin"
  '' + lib.optionalString pythonSupport ''
    mkdir -p $out/${python.sitePackages}
    mv $out/python/caffe $out/${python.sitePackages}
    rm -rf $out/python
  '';

  meta = with stdenv.lib; {
    description = "Deep learning framework";
    longDescription = ''
      Caffe is a deep learning framework made with expression, speed, and
      modularity in mind. It is developed by the Berkeley Vision and Learning
      Center (BVLC) and by community contributors.
    '';
    homepage = http://caffe.berkeleyvision.org/;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
