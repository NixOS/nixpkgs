{
  cmake,
  copyDesktopItems,
  fetchFromGitHub,
  flutter,
  lib,
  libayatana-appindicator,
  makeDesktopItem,
  stdenv,
  xdg-user-dirs,
  xorg,
}:

flutter.buildFlutterApplication rec {
  pname = "keyviz";
  version = "2.0.0a2";

  src = fetchFromGitHub {
    owner = "mulaRahul";
    repo = "keyviz";
    rev = "refs/tags/v${version}";
    hash = "sha256-yrVuKpPj7Ce2QipUr1EI2BQyfDTtnzLFQ+wCQWn68+I=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    window_size = "sha256-71PqQzf+qY23hTJvcm0Oye8tng3Asr42E2vfF1nBmVA=";
  };

  buildInputs =
    [
      xdg-user-dirs
      libayatana-appindicator
    ]
    ++ lib.optionals stdenv.isLinux (
      with xorg;
      [
        libICE
        libSM
        libX11
        libXext
        libXi
      ]
    );

  # hid_listener.dart use CMake find_package(X11 REQUIRED)
  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/app/data/flutter_assets/assets/img/logo.svg $out/share/icons/hicolor/scalable/apps/keyviz.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "keyviz";
      exec = "keyviz";
      icon = "keyviz";
      desktopName = "keyviz";
      genericName = "keyviz";
      comment = meta.description;
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Tool to visualize your keystrokes and mouse actions in real-time";
    homepage = "https://github.com/mulaRahul/keyviz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Cyberczy ];
    mainProgram = "keyviz";
    platforms = lib.platforms.linux; # MacOS is supported but I have no device to test
  };
}
