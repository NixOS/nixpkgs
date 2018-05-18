{ stdenv, lib
, fetchFromGitHub
, cmake
, boost
, google-gflags
, glog
, hdf5-cpp
, leveldb
, lmdb
, opencv3
, protobuf
, snappy
, doxygen
, openblas
, cudaSupport ? true, cudatoolkit
, cudnnSupport ? false, cudnn ? null
, ncclSupport ? false, nccl ? null
, pythonSupport ? false, python ? null, numpy ? null
}:

assert cudnnSupport -> cudaSupport;
assert ncclSupport -> cudaSupport;
assert pythonSupport -> (python != null && numpy != null);

stdenv.mkDerivation rec {
  name = "caffe-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "BVLC";
    repo = "caffe";
    rev = version;
    sha256 = "104jp3cm823i3cdph7hgsnj6l77ygbwsy35mdmzhmsi4jxprd9j3";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake doxygen ];

  cmakeFlags =
    [ (if pythonSupport then "-Dpython_version=${python.version}" else "-DBUILD_python=OFF")
      "-DBLAS=open"
    ] ++ (if cudaSupport then [
           "-DCUDA_ARCH_NAME=All"
           "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
         ] else [ "-DCPU_ONLY=ON" ])
      ++ lib.optional ncclSupport "-DUSE_NCCL=ON";

  buildInputs = [ boost google-gflags glog protobuf hdf5-cpp lmdb leveldb snappy opencv3 openblas ]
                ++ lib.optional cudaSupport cudatoolkit
                ++ lib.optional cudnnSupport cudnn
                ++ lib.optional ncclSupport nccl
                ++ lib.optionals pythonSupport [ python numpy ];

  propagatedBuildInputs = lib.optional pythonSupport python.pkgs.protobuf;

  outputs = [ "bin" "out"];
  propagatedBuildOutputs = []; # otherwise propagates out -> bin cycle

  preConfigure = lib.optionalString (cudaSupport && lib.versionAtLeast cudatoolkit.version "9.0") ''
    # CUDA 9.0 doesn't support sm_20
    sed -i 's,20 21(20) ,,' cmake/Cuda.cmake
  '' + lib.optionalString (python.isPy3 or false) ''
    sed -i \
      -e 's,"python-py''${boost_py_version}",python3,g' \
      -e 's,''${Boost_PYTHON-PY''${boost_py_version}_FOUND},''${Boost_PYTHON3_FOUND},g' \
      cmake/Dependencies.cmake
  '';

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
