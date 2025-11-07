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
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "scitokens";
    repo = "scitokens-cpp";

    rev = "v1.1.3";
    hash = "sha256-5EVN/Q4/veNsIdTKcULdKJ+BmRodelfo+CTdrfvkkK8=";
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

  meta = with lib; {
    homepage = "https://github.com/scitokens/scitokens-cpp/";
    description = "C++ implementation of the SciTokens library with a C library interface";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ evey ];
  };
}
