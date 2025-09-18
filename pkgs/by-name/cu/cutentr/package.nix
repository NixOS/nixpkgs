{
  stdenv,
  libsForQt5,
  fetchFromGitLab,
  makeDesktopItem,
  lib,
  copyDesktopItems,
}:

let
  version = "0.3.3";
in

stdenv.mkDerivation {
  pname = "cutentr";
  inherit version;

  src = fetchFromGitLab {
    owner = "BoltsJ";
    repo = "cuteNTR";
    tag = version;
    hash = "sha256-KfnC9R38qSMhQDeaMBWm1HoO3Wzs5kyfPFwdMZCWw4E=";
  };

  desktopItems = lib.singleton (makeDesktopItem {
    name = "cuteNTR";
    desktopName = "cuteNTR";
    icon = "cutentr";
    exec = "cutentr";
    categories = [ "Game" ];
  });

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    libsForQt5.qtbase
  ];

  buildPhase = ''
    runHook preBuild
    qmake
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r cutentr $out/bin

    install -m 444 -D setup/gui/com.gitlab.BoltsJ.cuteNTR.svg $out/share/icons/hicolor/scalable/apps/cutentr.svg
    runHook postInstall
  '';

  meta = {
    description = "3DS streaming client for Linux";
    homepage = "https://gitlab.com/BoltsJ/cuteNTR";
    license = lib.licenses.gpl3Plus;
    mainProgram = "cutentr";
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.EarthGman ];
  };
}
