{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtquickcontrols2,
  qtserialport,
  qtsvg,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "serial-studio";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "Serial-Studio";
    repo = "Serial-Studio";
    rev = "v${version}";
    hash = "sha256-Tsd1PGB7cO8h3HDifOtB8jsnj+fS4a/o5nfLoohVLM4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtquickcontrols2
    qtserialport
    qtsvg
  ];

  meta = with lib; {
    description = "Multi-purpose serial data visualization & processing program";
    mainProgram = "serial-studio";
    homepage = "https://serial-studio.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
