{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  cmake,
  boost,
  gflags,
  glog,
  hdf5-cpp,
  opencv4,
  protobuf,
  doxygen,
  blas,
  lmdbSupport ? true,
  lmdb,
  leveldbSupport ? true,
  leveldb,
  snappy,
  pythonSupport ? false,
  python ? null,
  numpy ? null,
  replaceVars,
}:

let
  toggle = bool: if bool then "ON" else "OFF";

  test_model_weights = fetchurl {
    url = "http://dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel";
    sha256 = "472d4a06035497b180636d8a82667129960371375bd10fcb6df5c6c7631f25e0";
  };
in

stdenv.mkDerivation rec {
  pname = "caffe";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "BVLC";
    repo = "caffe";
    rev = version;
    sha256 = "104jp3cm823i3cdph7hgsnj6l77ygbwsy35mdmzhmsi4jxprd9j3";
  };

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  cmakeFlags =
    # It's important that caffe is passed the major and minor version only because that's what
    # boost_python expects
    [
      (if pythonSupport then "-Dpython_version=${python.pythonVersion}" else "-DBUILD_python=OFF")
      "-DBLAS=open"
      "-DCPU_ONLY=ON"
    ]
    ++ [ "-DUSE_LEVELDB=${toggle leveldbSupport}" ]
    ++ [ "-DUSE_LMDB=${toggle lmdbSupport}" ];

  buildInputs = [
    boost
    gflags
    glog
    protobuf
    hdf5-cpp
    opencv4
    blas
  ]
  ++ lib.optional lmdbSupport lmdb
  ++ lib.optionals leveldbSupport [
    leveldb
    snappy
  ]
  ++ lib.optionals pythonSupport [
    python
    numpy
  ];

  propagatedBuildInputs = lib.optionals pythonSupport (
    # requirements.txt
    let
      pp = python.pkgs;
    in
    (
      [
        pp.numpy
        pp.scipy
        pp.scikit-image
        pp.h5py
        pp.matplotlib
        pp.ipython
        pp.networkx
        pp.pandas
        pp.python-dateutil
        pp.protobuf
        pp.gflags
        pp.pyyaml
        pp.pillow
        pp.six
      ]
      ++ lib.optional leveldbSupport pp.leveldb
    )
  );

  outputs = [
    "bin"
    "out"
  ];
  propagatedBuildOutputs = [ ]; # otherwise propagates out -> bin cycle

  patches = [
    ./darwin.patch
    ./glog-cmake.patch
    ./random-shuffle.patch
    (fetchpatch {
      name = "support-opencv4";
      url = "https://github.com/BVLC/caffe/pull/6638/commits/0a04cc2ccd37ba36843c18fea2d5cbae6e7dd2b5.patch";
      hash = "sha256-ZegTvp0tTHlopQv+UzHDigs6XLkP2VfqLCWXl6aKJSI=";
    })
  ]
  ++ lib.optional pythonSupport (
    replaceVars ./python.patch {
      inherit (python.sourceVersion) major minor; # Should be changed in case of PyPy
    }
  );

  postPatch = ''
    substituteInPlace src/caffe/util/io.cpp --replace \
      'SetTotalBytesLimit(kProtoReadBytesLimit, 536870912)' \
      'SetTotalBytesLimit(kProtoReadBytesLimit)'
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
  ''
  + lib.optionalString pythonSupport ''
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

  meta = with lib; {
    description = "Deep learning framework";
    longDescription = ''
      Caffe is a deep learning framework made with expression, speed, and
      modularity in mind. It is developed by the Berkeley Vision and Learning
      Center (BVLC) and by community contributors.
    '';
    homepage = "http://caffe.berkeleyvision.org/";
    maintainers = [ ];
    broken =
      (pythonSupport && (python.isPy310))
      || !(leveldbSupport -> (leveldb != null && snappy != null))
      || !(pythonSupport -> (python != null && numpy != null));
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
