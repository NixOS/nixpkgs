{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "http-getter";
  version = "unstable-2020-12-08";

  src = fetchFromGitHub {
    owner = "tohojo";
    repo = "http-getter";
    rev = "0b20f08133206aaf225946814ceb6b85ab37e136";
    sha256 = "0plyqqwfm9bysichda0w3akbdxf6279wd4mx8mda0c4mxd4xy9nl";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ curl ];

  meta = with lib; {
    homepage = "https://github.com/tohojo/http-getter";
    description = "Simple getter for HTTP URLs using cURL";
    mainProgram = "http-getter";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
