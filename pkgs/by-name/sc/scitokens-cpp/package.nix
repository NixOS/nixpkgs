{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libuuid,
  curl,
  sqlite,
  openssl,
}:

stdenv.mkDerivation {
  pname = "scitokens-cpp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "scitokens";
    repo = "scitokens-cpp";

    rev = "v1.4.0";
    hash = "sha256-axuWt4w8pPupJ0he2Zh1bAkiXn+Z0uUFtDjrFEyh7QY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libuuid
    openssl
    curl
    sqlite
  ];

  meta = {
    homepage = "https://github.com/scitokens/scitokens-cpp/";
    description = "C++ implementation of the SciTokens library with a C library interface";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evey ];
  };
}
