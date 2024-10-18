{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libuuid, curl, sqlite, openssl }:

stdenv.mkDerivation rec {
  pname = "scitokens-cpp";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "scitokens";
    repo = "scitokens-cpp";

    rev = "v1.1.1";
    hash = "sha256-G3z9DYYWCNeA/rufNHQP3SwT5WS2AvUWm1rd8lx6XxA=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    libuuid
    openssl
    curl
    sqlite
  ];


  meta = with lib; {
    homepage = "https://github.com/scitokens/scitokens-cpp/";
    description =
      "A C++ implementation of the SciTokens library with a C library interface";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ evey ];
  };
}
