{ stdenv, lib, fetchFromGitHub, ccache, cmake, ctags, swig
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
