{ stdenv, lib, fetchFromGitHub, fetchpatch, fetchurl, cmake, ctags, swig
# data, compression
, bzip2, curl, hdf5, json_c, lzma, lzo, protobuf, snappy
# maths
, openblasCompat, eigen, nlopt, lp_solve, colpack, liblapack, glpk
# libraries
, libarchive, libxml2
# extra support
, pythonSupport ? true, pythonPackages ? null
, opencvSupport ? false, opencv ? null
}:

assert pythonSupport -> pythonPackages != null;
assert opencvSupport -> opencv != null;

let
  pname = "shogun";
  version = "6.1.4";
  rxcppVersion = "4.0.0";
  gtestVersion = "1.8.0";
  srcs = {
    toolbox = fetchFromGitHub {
      owner = pname + "-toolbox";
      repo = pname;
      rev = pname + "_" + version;
      sha256 = "38aULxK50wQ2+/ERosSpRyBmssmYSGv5aaWfWSlrSRc=";
      fetchSubmodules = true;
    };
    # we need the packed archive
    rxcpp = fetchurl {
      url = "https://github.com/Reactive-Extensions/RxCpp/archive/v${rxcppVersion}.tar.gz";
      sha256 = "0y2isr8dy2n1yjr9c5570kpc9lvdlch6jv0jvw000amwn5d3krsh";
    };
    gtest = fetchurl {
      url = "https://github.com/google/googletest/archive/release-${gtestVersion}.tar.gz";
      sha256 = "1n5p1m2m3fjrjdj752lf92f9wq3pl5cbsfrb49jqbg52ghkz99jq";
    };
  };
in

stdenv.mkDerivation rec {

  inherit pname version;

  src = srcs.toolbox;

  postUnpack = ''
    mkdir -p $sourceRoot/third_party/{rxcpp,gtest}
    ln -s ${srcs.rxcpp} $sourceRoot/third_party/rxcpp/v${rxcppVersion}.tar.gz
    ln -s ${srcs.gtest} $sourceRoot/third_party/gtest/release-${gtestVersion}.tar.gz
  '';

  # broken
  doCheck = false;

  patches = [
    (fetchpatch {
      url = "https://github.com/awild82/shogun/commit/365ce4c4c700736d2eec8ba6c975327a5ac2cd9b.patch";
      sha256 = "158hqv4xzw648pmjbwrhxjp7qcppqa7kvriif87gn3zdn711c49s";
    })
  ];

  CCACHE_DISABLE="1";
  CCACHE_DIR=".ccache";

  buildInputs = with lib; [
      openblasCompat bzip2 cmake colpack curl ctags eigen hdf5 json_c lp_solve lzma lzo
      protobuf nlopt snappy swig (libarchive.dev) libxml2 liblapack glpk
    ]
    ++ optionals (pythonSupport) (with pythonPackages; [ python ply numpy ])
    ++ optional  (opencvSupport) opencv;

  NIX_CFLAGS_COMPILE="-faligned-new";

  cmakeFlags =
  let
      onOff = b: if b then "ON" else "OFF";
      flag = n: b: "-D"+n+"="+onOff b;
  in
  with lib; [
    (flag "ENABLE_TESTING" doCheck)
    (flag "BUILD_META_EXAMPLES" doCheck)
    (flag "CMAKE_VERBOSE_MAKEFILE:BOOL" doCheck)
    (flag "PythonModular" pythonSupport)
    (flag "OpenCV" opencvSupport)
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A toolbox which offers a wide range of efficient and unified machine learning methods";
    homepage = "http://shogun-toolbox.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
  };
}
