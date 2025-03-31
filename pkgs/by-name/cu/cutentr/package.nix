{
  stdenv,
  libsForQt5,
  fetchFromGitLab,
  makeDesktopItem,
  fetchurl,
  lib,
  copyDesktopItems,
}:

let
  version = "0.3.3";

  icon = fetchurl {
    url = "https://gitlab.com/BoltsJ/cuteNTR/-/raw/${version}/setup/gui/com.gitlab.BoltsJ.cuteNTR.svg";
    hash = "sha256-bnSNJh13E2U11b+qW0SjfvZQ/VQi5Dbuz65g3svTgWo=";
  };
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

  nativeBuildInputs =
    with libsForQt5.qt5;
    [
      wrapQtAppsHook
    ]
    ++ [
      copyDesktopItems
    ];

  buildInputs = with libsForQt5.qt5; [
    qtbase
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

    mkdir -p $out/share/icons/hicolor/"512"x"512"/apps
    cp ${icon} $out/share/icons/hicolor/"512"x"512"/apps/cutentr.svg
    runHook postInstall
  '';

  meta = {
    description = "A 3DS streaming client for Linux";
    homepage = "https://gitlab.com/BoltsJ/cuteNTR";
    license = lib.licenses.gpl3Only;
    mainProgram = "cutentr";
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.EarthGman ];
  };
}
