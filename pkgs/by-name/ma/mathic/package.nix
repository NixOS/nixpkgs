{
  lib,
  fetchFromGitHub,
  stdenv,

  autoconf,
  automake,
  gtest,
  libtool,
  memtailor,
}:
let
  version = "1.2";
in
stdenv.mkDerivation {
  pname = "mathic";
  version = version;

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "mathic";
    rev = "refs/tags/v${version}";
    hash = "sha256-fC0PLX3Z9+xAtqTaxTWJWmZCbzVbQwowBfa/83jw1uY=";
  };

  buildInputs = [
    memtailor
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gtest
    libtool
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  installFlags = "PREFIX=$(out)";

  meta = {
    description = "C++ library of fast data structures designed for use in Groebner basis computation";
    longDescription = ''
      Mathic is a C++ library of fast data structures designed for use in
      Groebner basis computation. This includes data structures for ordering
      S-pairs, performing divisor queries and ordering polynomial terms during
      polynomial reduction.  With Mathic you get to use highly optimized code
      with little effort so that you can focus more of your time on whatever
      part of your Groebner basis implementation that you are interested in.
      The data structures use templates to allow you to use them with whatever
      representation of monomials/terms and coefficients that your code uses.
      In fact the only places where Mathic defines its own monomials/terms is
      in the test code and example code. Currently only dense representations
      of terms/monomials are suitable since Mathic will frequently ask "what is
      the exponent of variable number x in this term/monomial?".
    '';
    homepage = "https://github.com/Macaulay2/mathic";
    license = lib.licenses.lgpl2Plus;
  };
}
