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

stdenv.mkDerivation rec {
  pname = "scitokens-cpp";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "scitokens";
    repo = "scitokens-cpp";

    rev = "v1.1.2";
    hash = "sha256-87mV1hyoUI/pWzRXaI051H3+FN5TXcachhgAPTtQYHg=";
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
    description = "A C++ implementation of the SciTokens library with a C library interface";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evey ];
  };
}
