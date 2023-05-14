{ lib
, stdenv
, fetchFromGitHub
, cmake
, pdal
, curl
, openssl
}:

stdenv.mkDerivation rec {
  pname = "entwine";
  version = "unstable-2022-08-03";

  src = fetchFromGitHub {
    owner = "connormanning";
    repo = "entwine";
    rev = "c776d51fd6ab94705b74f78b26de7f853e6ceeae";
    sha256 = "sha256-dhYJhXtfMmqQLWuV3Dux/sGTsVxCI7RXR2sPlwIry0g=";
  };

  buildInputs = [
    openssl
    pdal
    curl
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Point cloud organization for massive datasets";
    homepage = "https://entwine.io/";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
  };
}
