{
  lib,
  fetchFromGitHub,
  flutter,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  pname = "flclash";
  version = "0.8.66";
  src =
    (fetchFromGitHub {
      owner = "chen08209";
      repo = "FlClash";
      rev = "v${version}";
      hash = "sha256-LkaAALJcP3DGXBMZ3QWLUiyT9Kr4yTxKIRqYhrW1WOw=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });
  libclash = buildGoModule {
    inherit pname version src;
    modRoot = "./core";
    vendorHash = "sha256-K+PrLFvDHyaxf1NKzcqf0qmfQwT8rctScv1CN+TxY0M=";
    buildPhase = ''
      runHook preBuild
      mkdir -p $out/lib
      go build -ldflags="-w -s" -tags=with_gvisor -buildmode=c-shared -o $out/lib/libclash.so
      runHook postBuild
    '';
  };
in
flutter.buildFlutterApplication {
  inherit pname version src;

  desktopItems = [
    (makeDesktopItem {
      name = "FlClash";
      exec = "FlClash %U";
      icon = "FlClash";
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

  patchPhase = ''
    runHook prePatch
    substituteInPlace lib/clash/core.dart --replace-fail 'DynamicLibrary.open("libclash.so")' 'DynamicLibrary.open("${libclash}/lib/libclash.so")'
    runHook postPatch
  '';

  preBuild = ''
    mkdir -p ./libclash/linux/
    cp ${libclash}/lib/libclash.so ./libclash/linux/libclash.so
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps/
    cp ./assets/images/icon.png $out/share/pixmaps/FlClash.png
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
    description = "Multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free";
    homepage = "https://github.com/chen08209/FlClash";
    mainProgram = "FlClash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
