{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
  libGLU,
  makeDesktopItem,
  copyDesktopItems,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "plater";
  version = "1.0.0-unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "Rhoban";
    repo = "Plater";
    rev = "6c4f924504979095b1b45cf8fd81b1e38f0f8642";
    hash = "sha256-+iL5Gl7k4lPikRwkyhaXSEcFYmhXV4ubAvP3iTBXDO8=";
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    copyDesktopItems
  ];
  buildInputs = [
    libGLU
    qt5.qtbase
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "plater";
      exec = "plater";
      icon = "plater";
      desktopName = "Ideamaker";
      genericName = meta.description;
      categories = [
        "Utility"
        "Engineering"
      ];
    })
  ];

  postInstall = ''
    install -D $src/gui/img/plater.png -t $out/share/icons/hicolor/128x128/apps
  '';

  meta = {
    description = "3D-printer parts placer and plate generator";
    homepage = "https://github.com/Rhoban/Plater";
    maintainers = with lib.maintainers; [ lovesegfault ];
    platforms = lib.platforms.linux;
    license = lib.licenses.cc-by-nc-30;
  };
}
