{ fetchFromGitHub, libiconv }:

finalAttrs: {
  version = "0.996";

  src = fetchFromGitHub {
    owner = "taku910";
    repo = "mecab";
    rev = "5a7db65493a0b57d5fc31734e65300320aaf94c8";
    hash = "sha256-elB0Zr8DDkw3IZvvqVG+OBspZxFLPnvUSM9SRSILYWs=";
    rootDir = "mecab";
  };

  buildInputs = [ libiconv ];

  configureFlags = [
    "--with-charset=utf8"
  ];

  # mecab uses several features that have been removed in C++17.
  # Force the language mode to C++14, so that it can compile with clang 16.
  makeFlags = [ "CXXFLAGS=-std=c++14" ];

  doCheck = true;
}
