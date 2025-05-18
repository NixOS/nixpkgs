{
  lib,
  fetchFromGitHub,
  flutter327,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
  udev,
  copyDesktopItems,
  makeDesktopItem,
}:

flutter327.buildFlutterApplication rec {
  pname = "intiface-central";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-central";
    tag = "v${version}";
    hash = "sha256-goN0750EvGw5G8cb4jy6wWnjlLwlwMeTz4GQEilbwpY=";
  };

  patches = [
    ./corrosion.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = "${src.name}/intiface-engine-flutter-bridge";
    hash = "sha256-z9i0xT0e8G9spOmXpI2yFee/y3ZEh69YqL+7zRWszzA=";
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

  meta = {
    mainProgram = "intiface_central";
    description = "Intiface Central (Buttplug Frontend) Application for Desktop";
    homepage = "https://intiface.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _999eagle ];
    platforms = lib.platforms.linux;
  };
}
