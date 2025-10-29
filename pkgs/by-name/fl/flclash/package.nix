{
  lib,
  fetchFromGitHub,
  flutter332,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:

let
  pname = "flclash";
  version = "0.8.87";

  src =
    (fetchFromGitHub {
      owner = "chen08209";
      repo = "FlClash";
      tag = "v${version}";
      hash = "sha256-vGRq9Kc6XU6r3huIGAKoh5x46fFS8jmXgus9WgpvG3A=";
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
    maintainers = [ ];
  };

  libclash = buildGoModule {
    inherit version src;
    pname = "libclash";

    modRoot = "core";

    vendorHash = "sha256-Uc+RvpW3vndPFnM7yhqrNTEexAPaolCk8YK8u/+55RQ=";

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
flutter332.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    flutter_js = "sha256-4PgiUL7aBnWVOmz2bcSxKt81BRVMnopabj5LDbtPYk4=";
    re_editor = "sha256-PuaXoByTmkov2Dsz0kBHBHr/o63+jgPrnY9gpK7AOhA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  flutterBuildFlags = [ "--dart-define=APP_ENV=stable" ];

  desktopItems = [
    (makeDesktopItem {
      name = "flclash";
      exec = "FlClash %U";
      icon = "flclash";
      genericName = "FlClash";
      desktopName = "FlClash";
      categories = [ "Network" ];
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

  passthru = {
    inherit libclash;
    updateScript = ./update.sh;
  };

  meta = metaCommon // {
    mainProgram = "FlClash";
    platforms = lib.platforms.linux;
  };
}
