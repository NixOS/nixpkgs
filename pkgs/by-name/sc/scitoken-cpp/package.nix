{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libuuid, curl, sqlite, openssl }:

stdenv.mkDerivation rec {
  pname = "scitoken-cpp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "scitokens";
    repo = "scitokens-cpp";

    rev = "v1.1.0";
    hash = "sha256-g97Ah5Oob0iOvMQegpG/AACLZCW37kA0RpSIcKOyQnE=";
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
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ evey ];
  };
}
