{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
  libGLU,
  makeDesktopItem,
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
  ];
  buildInputs = [
    libGLU
    qt5.qtbase
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
