{
  lib,
  fetchFromGitHub,
  flutter335,
  keybinder3,
  libayatana-appindicator,
  buildGoModule,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
}:

let
  pname = "flclash";
<<<<<<< HEAD
  version = "0.8.91";

  src = fetchFromGitHub {
    owner = "chen08209";
    repo = "FlClash";
    tag = "v${version}";
    preFetch = ''
      export GIT_CONFIG_COUNT=1
      export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
      export GIT_CONFIG_VALUE_0=git@github.com:
    '';
    hash = "sha256-jQ0phrTWlZZj5sVvnHAuC5h1nbJCcr/0wKw61mZMtes=";
    fetchSubmodules = true;
  };
=======
  version = "0.8.90";

  src =
    (fetchFromGitHub {
      owner = "chen08209";
      repo = "FlClash";
      tag = "v${version}";
      hash = "sha256-wEgWjzdP7HeWgDacaP9fYNczG9BrTN790AQ5aj9scwM=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Proxy client based on ClashMeta, simple and easy to use";
    homepage = "https://github.com/chen08209/FlClash";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
  };

  core = buildGoModule {
    pname = "core";
    inherit version src meta;

    modRoot = "core";

<<<<<<< HEAD
    vendorHash = "sha256-/natNGWXF6be7kyLYF2fHg0o0C1zkBAg1k8BAH5Dl9E=";
=======
    vendorHash = "sha256-5oYJMcyKh8CpMLOLch5/svwa148hY4rnSR5inTRNK4M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    env.CGO_ENABLED = 0;

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/bin
      go build -ldflags="-w -s" -tags=with_gvisor -o $out/bin/FlClashCore

      runHook postBuild
    '';
  };
in
flutter335.buildFlutterApplication {
  inherit pname version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

<<<<<<< HEAD
  gitHashes = lib.importJSON ./git-hashes.json;
=======
  gitHashes = {
    flutter_js = "sha256-4PgiUL7aBnWVOmz2bcSxKt81BRVMnopabj5LDbtPYk4=";
    re_editor = "sha256-PuaXoByTmkov2Dsz0kBHBHr/o63+jgPrnY9gpK7AOhA=";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    cp ${core}/bin/FlClashCore libclash/linux/FlClashCore
  '';

  postInstall = ''
    install -D --mode=0644 assets/images/icon.png $out/share/pixmaps/flclash.png
  '';

  passthru = {
    inherit core;
    updateScript = ./update.sh;
  };

  meta = meta // {
    mainProgram = "FlClash";
    platforms = lib.platforms.linux;
  };
}
