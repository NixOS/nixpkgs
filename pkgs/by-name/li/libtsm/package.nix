{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation {
  pname = "libtsm";
  version = "4.0.2-unstable-2023-12-24";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "libtsm";
    rev = "69922bde02c7af83b4d48a414cc6036af7388626";
    sha256 = "sha256-Rug3OWSbbiIivItULPNNptClIZ/PrXdQeUypAAxrUY8=";
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
