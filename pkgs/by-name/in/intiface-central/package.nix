{
  lib,
  fetchFromGitHub,
  flutter329,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
  udev,
  copyDesktopItems,
  makeDesktopItem,
}:

flutter329.buildFlutterApplication rec {
  pname = "intiface-central";
  version = "2.6.7";

  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-central";
    tag = "v${version}";
    hash = "sha256-ePk0I6Uf2/eaBKSZumv/kF9MJOB+MWQ4/FnQ19lE3ZQ=";
  };

  patches = [
    ./corrosion.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = "${src.name}/intiface-engine-flutter-bridge";
    hash = "sha256-EC0pdTG+BsVFbxixCeOIXCsMHi4pF3tug+YNVzaMn/A=";
  };

  cargoRoot = "intiface-engine-flutter-bridge";

  preConfigure = ''
    export CMAKE_PREFIX_PATH="${corrosion}:$CMAKE_PREFIX_PATH"
  '';

  nativeBuildInputs = [
    corrosion
    rustPlatform.cargoSetupHook
    cargo
    rustc
    copyDesktopItems
  ];

  buildInputs = [ udev ];

  # without this, only the splash screen will be shown and the logs will contain the
  # line `Failed to load dynamic library 'lib/libintiface_engine_flutter_bridge.so'`
  extraWrapProgramArgs = "--chdir $out/app/intiface-central";

  postInstall = ''
    install -Dm644 $out/app/intiface-central/data/flutter_assets/assets/icons/intiface_central_icon.png $out/share/pixmaps/intiface-central.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "intiface-central";
      exec = "intiface_central";
      icon = "intiface-central";
      comment = "Intiface Central (Buttplug Frontend) Application for Desktop";
      desktopName = "Intiface Central";
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    mainProgram = "intiface_central";
    description = "Intiface Central (Buttplug Frontend) Application for Desktop";
    homepage = "https://intiface.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _999eagle ];
    platforms = lib.platforms.linux;
  };
}
