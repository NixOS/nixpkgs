{ stdenv, lib, fetchFromGitHub, fetchpatch, ccache, cmake, ctags, swig
# data, compression
, bzip2, curl, hdf5, json_c, lzma, lzo, protobuf, snappy
# maths
, blas, eigen, nlopt, lp_solve, colpack
# libraries
, libarchive, liblapack, libxml2
# extra support
, pythonSupport ? true, pythonPackages ? null
, opencvSupport ? false, opencv ? null
}:

assert pythonSupport -> pythonPackages != null;
assert opencvSupport -> opencv != null;

stdenv.mkDerivation rec {
  pname = "shogun";
  version = "6.0.0";
  name = pname + "-" + version;

  src = fetchFromGitHub {
    owner = pname + "-toolbox";
    repo = pname;
    rev = pname + "_" + version;
    sha256 = "0f2zwzvn5apvwypkfkq371xp7c5bdb4g1fwqfh8c2d57ysjxhmgf";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "Fix-meta-example-parser-bug-in-parallel-builds.patch";
      url = "https://github.com/shogun-toolbox/shogun/commit/ecd6a8f11ac52748e89d27c7fab7f43c1de39f05.patch";
      sha256 = "1hrwwrj78sxhwcvgaz7n4kvh5y9snfcc4jf5xpgji5hjymnl311n";
    })
    (fetchpatch {
      url = "https://github.com/awild82/shogun/commit/365ce4c4c700736d2eec8ba6c975327a5ac2cd9b.patch";
      sha256 = "158hqv4xzw648pmjbwrhxjp7qcppqa7kvriif87gn3zdn711c49s";
    })
  ];

  CCACHE_DIR=".ccache";

  buildInputs = with lib; [
      blas bzip2 ccache cmake colpack curl ctags eigen hdf5 json_c lp_solve lzma lzo
      protobuf nlopt snappy swig (libarchive.dev) liblapack libxml2
    ]
    ++ optionals (pythonSupport) (with pythonPackages; [ python ply numpy ])
    ++ optional  (opencvSupport) opencv;

  cmakeFlags = with lib; []
    ++ (optional (pythonSupport) "-DPythonModular=ON")
    ++ (optional (opencvSupport) "-DOpenCV=ON")
    ;

  meta = with stdenv.lib; {
    description = "A toolbox which offers a wide range of efficient and unified machine learning methods";
    homepage = "http://shogun-toolbox.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
  };
}
