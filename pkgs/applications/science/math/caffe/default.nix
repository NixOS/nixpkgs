{ config, stdenv, lib
, fetchFromGitHub
, fetchurl
, cmake
, boost
, gflags
, glog
, hdf5-cpp
, opencv3
, protobuf
, doxygen
, openblas
, Accelerate, CoreGraphics, CoreVideo
, lmdbSupport ? true, lmdb
, leveldbSupport ? true, leveldb, snappy
, cudaSupport ? config.cudaSupport or false, cudatoolkit
, cudnnSupport ? cudaSupport, cudnn ? null
, ncclSupport ? false, nccl ? null
, pythonSupport ? false, python ? null, numpy ? null
, substituteAll
}:

assert leveldbSupport -> (leveldb != null && snappy != null);
assert cudnnSupport -> cudaSupport;
assert ncclSupport -> cudaSupport;
assert pythonSupport -> (python != null && numpy != null);

let
  toggle = bool: if bool then "ON" else "OFF";

  test_model_weights = fetchurl {
    url = "http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel";
    sha256 = "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0";
  };

in

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
    # It's important that caffe is passed the major and minor version only because that's what
    # boost_python expects
    [ (if pythonSupport then "-Dpython_version=${python.pythonVersion}" else "-DBUILD_python=OFF")
      "-DBLAS=open"
    ] ++ (if cudaSupport then [
           "-DCUDA_ARCH_NAME=All"
           "-DCUDA_HOST_COMPILER=${cudatoolkit.cc}/bin/cc"
         ] else [ "-DCPU_ONLY=ON" ])
      ++ ["-DUSE_NCCL=${toggle ncclSupport}"]
      ++ ["-DUSE_LEVELDB=${toggle leveldbSupport}"]
      ++ ["-DUSE_LMDB=${toggle lmdbSupport}"];

  buildInputs = [ boost gflags glog protobuf hdf5-cpp opencv3 openblas ]
                ++ lib.optional cudaSupport cudatoolkit
                ++ lib.optional cudnnSupport cudnn
                ++ lib.optional lmdbSupport lmdb
                ++ lib.optional ncclSupport nccl
                ++ lib.optionals leveldbSupport [ leveldb snappy ]
                ++ lib.optionals pythonSupport [ python numpy ]
                ++ lib.optionals stdenv.isDarwin [ Accelerate CoreGraphics CoreVideo ]
                ;

  propagatedBuildInputs = lib.optionals pythonSupport (
    # requirements.txt
    let pp = python.pkgs; in ([
      pp.numpy pp.scipy pp.scikitimage pp.h5py
      pp.matplotlib pp.ipython pp.networkx pp.nose
      pp.pandas pp.dateutil pp.protobuf pp.gflags
      pp.pyyaml pp.pillow pp.six
    ] ++ lib.optional leveldbSupport pp.leveldb)
  );

  outputs = [ "bin" "out" ];
  propagatedBuildOutputs = []; # otherwise propagates out -> bin cycle

  patches = [
    ./darwin.patch
  ] ++ lib.optional pythonSupport (substituteAll {
    src = ./python.patch;
    inherit (python.sourceVersion) major minor;  # Should be changed in case of PyPy
  });

  postPatch = lib.optionalString (cudaSupport && lib.versionAtLeast cudatoolkit.version "9.0") ''
    # CUDA 9.0 doesn't support sm_20
    sed -i 's,20 21(20) ,,' cmake/Cuda.cmake
  '';

  preConfigure = lib.optionalString pythonSupport ''
    # We need this when building with Python bindings
    export BOOST_LIBRARYDIR="${boost.out}/lib";
  '';

  postInstall = ''
    # Internal static library.
    rm $out/lib/libproto.a

    # Install models
    cp -a ../models $out/share/Caffe/models

    moveToOutput "bin" "$bin"
  '' + lib.optionalString pythonSupport ''
    mkdir -p $out/${python.sitePackages}
    mv $out/python/caffe $out/${python.sitePackages}
    rm -rf $out/python
  '';

  doInstallCheck = false; # build takes more than 30 min otherwise
  installCheckPhase = ''
    model=bvlc_reference_caffenet
    m_path="$out/share/Caffe/models/$model"
    $bin/bin/caffe test \
      -model "$m_path/deploy.prototxt" \
      -solver "$m_path/solver.prototxt" \
      -weights "${test_model_weights}"
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
    platforms = platforms.linux ++ platforms.darwin;
  };
}
