{
  lib,
  fetchFromGitHub,
  flutter322,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  makeDesktopItem,
  copyDesktopItems,
  stdenv,
}:
let
  pname = "flclash";
  version = "0.8.64";
  src =
    (fetchFromGitHub {
      owner = "chen08209";
      repo = "FlClash";
      rev = "v${version}";
      hash = "sha256-uk6vy2eBJqkOlROYjce9l0uVk4NOec7ddrfUuJ1FIzM=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });
  desktopItems = [
    (makeDesktopItem {
      name = "FlClash";
      exec = "FlClash %U";
      icon = "${src}/assets/images/icon.png";
      genericName = "FlClash";
      desktopName = "FlClash";
      categories = [
        "Network"
      ];
      keywords = [
        "FlClash"
        "Clash"
        "ClashMeta"
        "Proxy"
      ];
    })
  ];
  libclash = buildGoModule {
    inherit pname version src;
    modRoot = "./core";
    vendorHash = "sha256-2oDa0rwnT9lqHKnkOIsVqfh33jXeSrZ2exkow6UE05c=";
    buildPhase = ''
      runHook preBuild
      mkdir -p $out/lib
      go build -ldflags="-w -s" -tags=with_gvisor -buildmode=c-shared -o $out/lib/libclash.so
      runHook postBuild
    '';
  };
in
flutter322.buildFlutterApplication {
  inherit
    pname
    version
    src
    desktopItems
    ;

  patchPhase = ''
    runHook prePatch
    substituteInPlace lib/clash/core.dart --replace-fail 'DynamicLibrary.open("libclash.so")' 'DynamicLibrary.open("${libclash}/lib/libclash.so")'
    runHook postPatch
  '';

  preBuild = ''
    mkdir -p ./libclash/linux/
    cp ${libclash}/lib/libclash.so ./libclash/linux/libclash.so
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  meta = {
    description = "Multi-platform proxy client based on ClashMeta,simple and easy to use, open-source and ad-free";
    homepage = "https://github.com/chen08209/FlClash";
    mainProgram = "FlClash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
