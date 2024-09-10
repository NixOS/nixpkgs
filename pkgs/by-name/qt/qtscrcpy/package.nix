{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  scrcpy,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation rec {
  pname = "qtscrcpy";
  version = "2.2.1";

  src =
    (fetchFromGitHub {
      owner = "barry-ran";
      repo = "QtScrcpy";
      rev = "v${version}";
      hash = "sha256-PL/UvRNqvLaFuvSHbkJsaJ2nqRp5+ERM+rmlKVtbShk=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs =
    [ scrcpy ]
    ++ (with libsForQt5; [
      qtbase
      qtmultimedia
      qtx11extras
    ]);

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=sign-compare"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r ../output/x64/Release/* $out/bin
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "QtScrcpy";
      exec = "QtScrcpy %U";
      icon = "qtscrcpy";
      desktopName = "QtScrcpy";
      genericName = "Android Display Control";
      categories = [
        "Utility"
        "RemoteAccess"
      ];
    })
  ];

  meta = {
    description = "Android real-time display control software";
    homepage = "https://github.com/barry-ran/QtScrcpy";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.daru-san ];
    mainProgram = "QtScrcpy";
    platforms = lib.platforms.all;
  };
}
