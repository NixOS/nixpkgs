{
  lib,
  stdenv,
  bzip2,
  cmake,
  fetchFromGitHub,
  gtest,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sexpp";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "rnpgp";
    repo = "sexpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mNt6J8nhzT5sF28ktl3jOkQMKn6x9iE04MMrwwVxyZs=";
  };

  buildInputs = [
    zlib
    bzip2
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DBUILD_SHARED_LIBS=on"
    "-DWITH_SEXP_TESTS=on"
    "-DDOWNLOAD_GTEST=off"
    "-DWITH_SEXP_CLI=on"
    "-DWITH_SANITIZERS=off"
  ];

  nativeBuildInputs = [
    cmake
    gtest
    pkg-config
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  preConfigure = ''
    echo "v${finalAttrs.version}" > version.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/rnpgp/sexp";
    description = "S-expressions parser and generator C++ library, fully compliant to [https://people.csail.mit.edu/rivest/Sexp.txt]";
    mainProgram = "sexpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ribose-jeffreylau ];
  };
})
