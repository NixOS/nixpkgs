{ lib
, fetchFromGitHub
, flutter
, corrosion
, rustPlatform
, cargo
, rustc
, udev
, copyDesktopItems
, makeDesktopItem
}:
flutter.buildFlutterApplication rec {
  pname = "intiface-central";
  version = "2.5.3";
  src = fetchFromGitHub {
    owner = "intiface";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-i0G3wCfJ9Q7DEmVMrQv2K6fy4YRWsEMNns9zMZkJxvY=";
  };
  patches = [
    ./corrosion.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = "source/intiface-engine-flutter-bridge";
    hash = "sha256-0sCHa3rMaLYaUG3E3fmsLi0dSdb9vGyv7qNR3JQkXuU=";
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

  buildInputs = [
    udev
  ];

  # without this, only the splash screen will be shown and the logs will contain the
  # line `Failed to load dynamic library 'lib/libintiface_engine_flutter_bridge.so'`
  extraWrapProgramArgs = "--chdir $out/app";

  postInstall = ''
    mkdir -p $out/share/pixmaps
    cp $out/app/data/flutter_assets/assets/icons/intiface_central_icon.png $out/share/pixmaps/intiface-central.png
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

  meta = with lib; {
    mainProgram = "intiface_central";
    description = "Intiface Central (Buttplug Frontend) Application for Desktop";
    homepage = "https://intiface.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ _999eagle ];
    platforms = platforms.linux;
  };
}
