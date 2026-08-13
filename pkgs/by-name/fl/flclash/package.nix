{
  lib,
  fetchFromGitHub,
  flutter344,
  stdenv,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  rustPlatform,
  writeText,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  imagemagick,
}:

let
  pname = "flclash";
  version = "0.8.94";

  src = fetchFromGitHub {
    owner = "chen08209";
    repo = "FlClash";
    tag = "v${version}";
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
    hash = "sha256-kLSyLsnTzYspPQ2IZRGdUjHouFKvZWTvuYdcGxLWPdw=";
    fetchSubmodules = true;
  };

  meta = {
    description = "Proxy client based on ClashMeta, simple and easy to use";
    homepage = "https://github.com/chen08209/FlClash";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ VZstless ];
  };

  core = buildGoModule {
    pname = "core";
    inherit version src meta;

    modRoot = "core";

    vendorHash = "sha256-sf8PXdkqgq/0hxbxP26a73XLT88tGiH5NDV6LoiHuZM=";

    env.CGO_ENABLED = 0;

    buildPhase = ''
      runHook preBuild

      mkdir --parents $out/bin
      go build -ldflags="-w -s" -tags=with_gvisor -o $out/bin/FlClashCore

      runHook postBuild
    '';
  };

  rustApi = rustPlatform.buildRustPackage {
    pname = "rustApi";
    inherit version src meta;

    sourceRoot = "${src.name}/plugins/rust_api/rust";

    cargoHash = "sha256-8zY3VkbEatU78qUTDIocasw4ca/jC94NUjDvcKnkxAA=";

    installPhase = ''
      runHook preInstall

      mkdir --parents $out/lib
      cp target/*/release/librust_api.so $out/lib/

      runHook postInstall
    '';
  };
in
flutter344.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
    imagemagick
  ];

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  flutterBuildFlags = [ "--dart-define=APP_ENV=stable" ];

  # RustLib.init() loads librust_api.so with dlopen(), which ignores
  # RUNPATH and only consults LD_LIBRARY_PATH
  extraWrapProgramArgs = "--prefix LD_LIBRARY_PATH : $out/app/flclash/lib";

  desktopItems = [
    (makeDesktopItem {
      name = "flclash";
      exec = "FlClash %U";
      icon = "flclash";
      genericName = "FlClash";
      desktopName = "FlClash";
      categories = [ "Network" ];
      startupWMClass = "com.follow.clash";
      keywords = [
        "FlClash"
        "Clash"
        "ClashMeta"
        "Proxy"
      ];
    })
  ];

  customSourceBuilders = {
    setup =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "setup";
        inherit version src;
        inherit (src) passthru;

        postPatch =
          let
            cmakeLists = writeText "CMakeLists.txt" ''
              cmake_minimum_required(VERSION 3.10)
              set(PROJECT_NAME "setup")
              project(''${PROJECT_NAME} LANGUAGES CXX)
              get_filename_component(PROJECT_ROOT "''${CMAKE_SOURCE_DIR}" DIRECTORY)
              install(PROGRAMS "''${PROJECT_ROOT}/libclash/linux/FlClashCore"
                DESTINATION "''${CMAKE_BINARY_DIR}/bundle"
                COMPONENT Runtime
              )
            '';
          in
          ''
            cp ${cmakeLists} plugins/setup/linux/CMakeLists.txt
          '';

        installPhase = ''
          runHook preInstall

          mkdir --parents $out/plugins
          cp --recursive plugins/setup $out/plugins/

          runHook postInstall
        '';
      };

    rust_api =
      { version, src, ... }:
      stdenv.mkDerivation {
        pname = "rust_api";
        inherit version src;
        inherit (src) passthru;

        postPatch =
          let
            fakeCargokitCmake = writeText "FakeCargokit.cmake" ''
              function(apply_cargokit target manifest_dir lib_name any_symbol_name)
                set("''${target}_cargokit_lib" ${rustApi}/lib/librust_api.so PARENT_SCOPE)
              endfunction()
            '';
          in
          ''
            cp ${fakeCargokitCmake} plugins/rust_api/cargokit/cmake/cargokit.cmake
          '';

        installPhase = ''
          runHook preInstall

          mkdir --parents $out/plugins
          cp --recursive plugins/rust_api $out/plugins/

          runHook postInstall
        '';
      };
  };

  preBuild = ''
    mkdir --parents libclash/linux
    cp ${core}/bin/FlClashCore libclash/linux/FlClashCore
  '';

  postInstall = ''
    mkdir --parents $out/share/icons/hicolor/512x512/apps
    magick assets/images/icon.png -resize 512x512 $out/share/icons/hicolor/512x512/apps/flclash.png
  '';

  passthru = {
    inherit core rustApi;
    updateScript = ./update.sh;
  };

  meta = meta // {
    mainProgram = "FlClash";
    platforms = lib.platforms.linux;
  };
}
