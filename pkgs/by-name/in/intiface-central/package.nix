{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter338,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
  jdk,
  udev,
  zlib,
  copyDesktopItems,
  makeDesktopItem,
  runCommand,
  writeText,
  pkg-config,
  dbus,
}:

let
  zlib-root = runCommand "zlib-root" { } ''
    mkdir $out
    ln -s ${zlib.dev}/include $out/include
    ln -s ${zlib}/lib $out/lib
  '';

  pname = "intiface-central";

  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-central";
    tag = "v${version}";
    hash = "sha256-yKWaXkSjg7LMIKIeRfviu4SmStxl9BSXncJSxXJeU0Y=";
  };

  rustDep = rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/rust";

    preBuild = ''
      chmod +w ../..
      ln -s ${buttplug} ../../buttplug
    '';

    cargoHash = "sha256-HpmGmMMocLQ5/DJq8PJ5u04DipSlrReJ/3l76L9j8Yk=";

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      dbus
      udev
    ];

    passthru.libraryPath = "lib/librust_lib_intiface_central.so";
  };

  buttplug_dart = fetchFromGitHub {
    owner = "buttplugio";
    repo = "buttplug_dart";
    tag = "v1.0.0-beta1";
    hash = "sha256-cJJU/DRTuQawdfi0aMyi7Vfmv4GtUj7nEBRNYEuZ8JQ=";
  };

  buttplug = fetchFromGitHub {
    owner = "buttplugio";
    repo = "buttplug";
    tag = "intiface_engine-4.0.0";
    hash = "sha256-F3mMQviTeyw9Wlrf8vcbJ9oGTYoKCIpPbj2jayQlpeg=";
  };
in
flutter338.buildFlutterApplication {
  inherit pname version src;

  patches = [
    ./corrosion.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.buttplug = "sha256-nm9TdEL9+80hCbaPnpAJTQ0w1t40vWYcxyilQTwvEBU=";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "${src.name}/rust";
    hash = rustDep.cargoHash;
  };

  cargoRoot = "rust";

  customSourceBuilders = {
    rust_lib_intiface_central =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "rust_lib_intiface_central";
        inherit version src;
        inherit (src) passthru;

        postPatch =
          let
            fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
              function(apply_cargokit target manifest_dir lib_name any_symbol_name)
                set("''${target}_cargokit_lib" ${rustDep}/${rustDep.passthru.libraryPath} PARENT_SCOPE)
              endfunction()
            '';
          in
          ''
            cp ${fakeCargokitCmake} rust_builder/cargokit/cmake/cargokit.cmake
          '';

        installPhase = ''
          runHook preInstall

          cp -r . "$out"

          runHook postInstall
        '';
      };
  };

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
    jdk
    udev
  ];

  env.ZLIB_ROOT = zlib-root;

  preBuild = ''
    chmod +w ..
    ln -s ${buttplug_dart} ../buttplug_dart
    ln -s ${buttplug} ../buttplug
  '';

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
