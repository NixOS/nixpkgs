{
  lib,
  stdenv,
  fetchgit,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation {
  pname = "qscreenshot";
  version = "unstable-2021-10-18";

  src = fetchgit {
    url = "https://git.code.sf.net/p/qscreenshot/code";
    rev = "e340f06ae2f1a92a353eaa68e103d1c840adc12d";
    sha256 = "0mdiwn74vngiyazr3lq72f3jnv5zw8wyd2dw6rik6dbrvfs69jig";
  };

  preConfigure = "cd qScreenshot";

  nativeBuildInputs = [
    cmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtx11extras
  ];

  postPatch = ''
    substituteInPlace qScreenshot/{CMakeLists.txt,cmake/modules/version.cmake} \
      --replace-fail "cmake_minimum_required( VERSION 3.2.0 )" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Simple creation and editing of screenshots";
    mainProgram = "qScreenshot";
    homepage = "https://sourceforge.net/projects/qscreenshot/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
    # last successful hydra build on darwin was in 2019
    broken = stdenv.hostPlatform.isDarwin;
  };
}
