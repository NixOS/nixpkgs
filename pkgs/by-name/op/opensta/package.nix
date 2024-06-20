{ lib
, stdenv
, cmake
, flex
, bison
, swig4
, fetchFromGitHub
, fetchurl
, tcl
, tclreadline
, zlib
}:

let
  cudd = stdenv.mkDerivation rec {
    pname = "cudd";
    version = "3.0.0";

    src = fetchurl {
      url = "https://github.com/davidkebo/cudd/raw/main/cudd_versions/cudd-${version}.tar.gz";
      hash = "sha256-uOlmtFYslqA+f76iOXKVh9ezldU8rcw5pyA7Sc9+62k=";
    };

    meta = with lib; {
      description = "Package for manipulation of binary and other kinds of decision diagrams";
      homepage = "https://davidkebo.com/cudd/";
      license = licenses.bsd3;
    };
  };
in stdenv.mkDerivation rec {
  pname = "opensta";
  version = "0-unstable-2024-03-21";

  src = fetchFromGitHub {
    owner = "parallaxsw";
    repo = "OpenSTA";
    rev = "8bf51ab7ee5c544d4f12d33f8f26c09a70914dfa";
    hash = "sha256-As2jbIS04p5FsSCNtuQFuTLY3+nAAPMZsYjJnPQAcCU=";
  };

  nativeBuildInputs = [
    cmake
    flex
    bison
    swig4
  ];

  buildInputs = [
    tcl
    tclreadline
    zlib
    cudd
  ];

  cmakeFlags = [
    "-DTCL_LIB_PATHS=${tcl}"
    "-DUSE_TCL_READLINE=ON"
    "-DUSE_CUDD=ON"
    "-DCUDD_DIR=${cudd}"
  ];

  meta = with lib; {
    description = "OpenSTA - Parallax Static Timing Analyzer";
    homepage = "https://github.com/parallaxsw/OpenSTA";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.povik ];
  };
}
