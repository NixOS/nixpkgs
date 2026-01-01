{
  lib,
  fetchFromGitHub,
<<<<<<< HEAD
  flutter332,
=======
  flutter329,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  corrosion,
  rustPlatform,
  cargo,
  rustc,
<<<<<<< HEAD
  jdk,
  udev,
  zlib,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
}:

let
  zlib-root = runCommand "zlib-root" { } ''
    mkdir $out
    ln -s ${zlib.dev}/include $out/include
    ln -s ${zlib}/lib $out/lib
  '';

  pname = "intiface-central";

  version = "2.6.8-unstable-2025-09-14";
=======
  udev,
  copyDesktopItems,
  makeDesktopItem,
}:

flutter329.buildFlutterApplication rec {
  pname = "intiface-central";
  version = "2.6.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-central";
<<<<<<< HEAD
    rev = "17877c623ad7e47fccfbb0acd6d191d672dc5053";
    hash = "sha256-sXvV3T/3Po2doDWXxiiJhAbQidwPPTS5300tEbgP83g=";
  };
in
flutter332.buildFlutterApplication {
  inherit pname version src;
=======
    tag = "v${version}";
    hash = "sha256-ePk0I6Uf2/eaBKSZumv/kF9MJOB+MWQ4/FnQ19lE3ZQ=";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  patches = [
    ./corrosion.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  cargoDeps = rustPlatform.fetchCargoVendor {
<<<<<<< HEAD
    inherit pname version src;
    sourceRoot = "${src.name}/intiface-engine-flutter-bridge";
    hash = "sha256-S+TonMTj3xb9oVo17hfjbl448pEvR+3sTTI8ePFjYXk=";
=======
    name = "${pname}-${version}-cargo-deps";
    inherit src;
    sourceRoot = "${src.name}/intiface-engine-flutter-bridge";
    hash = "sha256-EC0pdTG+BsVFbxixCeOIXCsMHi4pF3tug+YNVzaMn/A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  buildInputs = [
    jdk
    udev
  ];

  env.ZLIB_ROOT = zlib-root;
=======
  buildInputs = [ udev ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
