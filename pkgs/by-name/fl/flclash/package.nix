{
  lib,
  fetchFromGitHub,
  flutter327,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:
let
  pname = "flclash";
  version = "0.8.72";

  src =
    (fetchFromGitHub {
      owner = "chen08209";
      repo = "FlClash";
      tag = "v${version}";
      hash = "sha256-lcsIYsRMztAGrnN/Jmfv+aFfntroYk5eE4cTTj3c+9o=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  metaCommon = {
    description = "Multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free";
    homepage = "https://github.com/chen08209/FlClash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
  };

  libclash = buildGoModule {
    inherit pname version src;

    modRoot = "./core";

    vendorHash = "sha256-tT+rXv5NvknHWZLYm9DKlA/YCXwUkqdwGIekxBgc4pk=";

    env.CGO_ENABLED = 0;

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/bin
      go build -ldflags="-w -s" -tags=with_gvisor -o $out/bin/FlClashCore

      runHook postBuild
    '';

    meta = metaCommon;
  };
in
flutter327.buildFlutterApplication {
  inherit
    pname
    version
    src
    libclash
    ;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "flclash";
      exec = "FlClash %U";
      icon = "flclash";
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

  preBuild = ''
    mkdir -p libclash/linux
    cp ${libclash}/bin/FlClashCore libclash/linux/FlClashCore
  '';

  postInstall = ''
    install -Dm644 assets/images/icon.png $out/share/pixmaps/flclash.png
  '';

  passthru.updateScript = ./update.sh;

  meta = metaCommon // {
    mainProgram = "FlClash";
    platforms = lib.platforms.linux;
  };
}
