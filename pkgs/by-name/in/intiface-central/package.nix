{ lib
, fetchFromGitHub
, flutterPackages
, corrosion
, rustPlatform
, cargo
, rustc
, udev
, copyDesktopItems
, makeDesktopItem
}:
flutterPackages.v3_19.buildFlutterApplication rec {
  pname = "intiface-central";
  version = "2.6.0";
  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-central";
    rev = "v${version}";
    hash = "sha256-7+rw0cD8MJPFOkgmfHD6y+EojTGQhb15o1mn2p14eoE=";
  };
  patches = [
    ./corrosion.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  cargoDeps = rustPlatform.fetchCargoTarball {
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = "${src.name}/intiface-engine-flutter-bridge";
    hash = "sha256-tPkLZmHReY1TU2qcY4aGWsQPhLFowrqxTPwmTHZ5fDE=";
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
