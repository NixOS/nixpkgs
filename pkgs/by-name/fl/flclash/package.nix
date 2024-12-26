{
  lib,
  fetchFromGitHub,
  flutter324,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  autoPatchelfHook,
}:
let
  pname = "flclash";
  version = "0.8.70";
  src =
    (fetchFromGitHub {
      owner = "chen08209";
      repo = "FlClash";
      tag = "v${version}";
      hash = "sha256-6gDkRqbAGqwF+HCThWAHK0Jh/dxaYlnaYaAiXN48z5E=";
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

    vendorHash = "sha256-yam3DgY/dfwIRc7OvFltwX29x6xGlrrsK4Oj6oaGYRw=";

    CGO_ENABLED = 0;

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/bin
      go build -ldflags="-w -s" -tags=with_gvisor -o $out/bin/FlClashCore

      runHook postBuild
    '';

    meta = {
      description = "Multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free";
      homepage = "https://github.com/chen08209/FlClash";
      license = with lib.licenses; [ gpl3Plus ];
      maintainers = with lib.maintainers; [ aucub ];
    };
  };
in
flutter324.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
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
    mkdir -p ./libclash/linux/
    cp ${libclash}/bin/FlClashCore ./libclash/linux/FlClashCore
  '';

  postInstall = ''
    install -Dm644 ./assets/images/icon.png $out/share/pixmaps/flclash.png
  '';

  meta = {
    description = "Multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free";
    homepage = "https://github.com/chen08209/FlClash";
    mainProgram = "FlClash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
