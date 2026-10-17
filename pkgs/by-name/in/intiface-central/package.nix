{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter347,
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

  version = "3.1.1+43";

  src = fetchFromGitHub {
    owner = "intiface";
    repo = "intiface-central";
    tag = "v${version}";
    hash = "sha256-9oej7XjqkFJmmGqfTPpIX1IfofbyAn4HE+mk9KbcqZ8=";
  };

  rustDep = rustPlatform.buildRustPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/rust";

    preBuild = ''
      chmod +w ../..
      ln -s ${buttplug} ../../buttplug
    '';

    cargoHash = "sha256-21B8pnFxBvxt5DtnfjQpyaNA8Yu3dxgUj7Nb89X0bg0=";

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
    tag = "v1.0.0";
    hash = "sha256-nm9TdEL9+80hCbaPnpAJTQ0w1t40vWYcxyilQTwvEBU=";
  };

  buttplug = fetchFromGitHub {
    owner = "buttplugio";
    repo = "buttplug";
    tag = "intiface-engine-4.1.0";
    hash = "sha256-CeOaxJ+0Kf1eBu0XlelQ3Nvq+cstiLBidgF9ms1yD/Q=";
  };
in
flutter347.buildFlutterApplication {
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

  # without this, only the splash screen will be shown
  extraWrapProgramArgs = "--set FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR $out/app/intiface-central/lib";

  postInstall = ''
    install -Dm644 $out/app/intiface-central/data/flutter_assets/assets/icons/intiface_central_icon.png $out/share/icons/hicolor/512x512/apps/intiface-central.png
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
