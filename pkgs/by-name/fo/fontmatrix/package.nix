{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "fontmatrix";
  version = "0.9.100";

  src = fetchFromGitHub {
    owner = "fontmatrix";
    repo = "fontmatrix";
    rev = "v${version}";
    sha256 = "sha256-DtajGhx79DiecglXHja9q/TKVq8Jl2faQdA5Ib/yT88=";
  };

  buildInputs = [
    libsForQt5.qttools
    libsForQt5.qtwebkit
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Free/libre font explorer for Linux, Windows and Mac";
    homepage = "https://github.com/fontmatrix/fontmatrix";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
