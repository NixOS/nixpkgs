{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
  libGLU,
  makeDesktopItem,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "plater";
  version = "2020-07-30";

  src = fetchFromGitHub {
    owner = "Rhoban";
    repo = "Plater";
    rev = "f8de6d038f95a9edebfcfe142c8e9783697d5b47";
    hash = "sha256-JFs/p7psUEpy3LC7R03OCVxt/vENy6aiCvub0P6qQGQ=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libGLU
    libsForQt5.qtbase
  ];

  desktopItem = makeDesktopItem {
    name = "plater";
    exec = "plater";
    icon = "plater";
    desktopName = "Ideamaker";
    genericName = meta.description;
    categories = [
      "Utility"
      "Engineering"
    ];
  };

  postInstall = ''
    mkdir -p $out/share/pixmaps
    ln -s ${desktopItem}/share/applications $out/share/
    cp $src/gui/img/plater.png $out/share/pixmaps/${pname}.png
  '';

  meta = {
    description = "3D-printer parts placer and plate generator";
    homepage = "https://github.com/Rhoban/Plater";
    maintainers = with lib.maintainers; [ lovesegfault ];
    platforms = lib.platforms.linux;
    license = lib.licenses.cc-by-nc-30;
  };
}
