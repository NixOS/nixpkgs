{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  pkg-config,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "libtsm";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "libtsm";
    rev = "v${version}";
    sha256 = "sha256-C/IfFSBrQc6QdUARPAqbtcI3y3Uy0XurUaqLTY0MfuY=";
  };

  buildInputs = [ libxkbcommon ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
