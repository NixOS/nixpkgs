{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linvstmanager";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Goli4thus";
    repo = "linvstmanager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K6eugimMy/MZgHYkg+zfF8DDqUuqqoeymxHtcFGu2Uk=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Graphical companion application for various bridges like LinVst, etc";
    mainProgram = "linvstmanager";
    homepage = "https://github.com/Goli4thus/linvstmanager";
    license = with lib.licenses; [ gpl3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GabrielDougherty ];
  };
})
