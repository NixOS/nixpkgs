{
  lib,
  fetchFromGitHub,
  flutter344,
  buildGoModule,
  rustPlatform,
  stdenv,
  fetchpatch,
  replaceVars,
  keybinder3,
  libayatana-appindicator,
  makeDesktopItem,
  copyDesktopItems,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

flutter344.buildFlutterApplication (finalAttrs: {
  pname = "bettbox";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "appshubcc";
    repo = "Bettbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vK9/pst4KQtVdYOA+HPVl76FL5I8VgrtG7xUztaQ/CA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # Under `__structuredAttrs = true`, passAsFile leaves pubspecLockFilePath empty.
  env.pubspecLockFilePath = "./pubspec.lock.json";

  customSourceBuilders.code_forge =
    { version, src, ... }:
    let
      rustDeps = rustPlatform.buildRustPackage {
        pname = "code_forge-rust";
        inherit version src;

        cargoRoot = "plugins/code_forge/rust";
        buildAndTestSubdir = "plugins/code_forge/rust";
        cargoHash = "sha256-T/8JLe4SDZslp/bNKbTwGpAEbN54u9AxBSxj965iTqU=";
        passthru.libraryPath = "lib/libcode_forge.so";
      };
    in
    stdenv.mkDerivation {
      pname = "code_forge";
      inherit version src;
      inherit (src) passthru;

      patches = [
        (replaceVars ./cargokit.patch { output_lib = "${rustDeps}/${rustDeps.passthru.libraryPath}"; })
      ];

      dontBuild = true;

      installPhase = ''
        runHook preInstall

        cp -r . $out

        runHook postInstall
      '';
    };

  patches = [
    # drop libX11 dependency
    (fetchpatch {
      url = "https://github.com/appshubcc/Bettbox/commit/b6b86132f9851bf3970a05b50febd0bceb8e3ad8.patch";
      hash = "sha256-ZMZI9tvOcFdi3PhbBqlJNOY1jdi0gT9pw777FtdMfOM=";
      revert = true;
      excludes = [ "lib/common/tray.dart" ];
    })

    # we use nixpkgs's hotkey_manager_linux instead of overriding it
    (fetchpatch {
      url = "https://github.com/appshubcc/Bettbox/commit/49b456afb44e656fe09d95c76e9da1c4256d31fa.patch";
      hash = "sha256-jTN0IUK7z7DBjwaqhrfqX33hh4M/SOwjWxXy3DO6oGo=";
      revert = true;
      excludes = [ "pubspec.yaml" ];
    })
    ./pubspec.yaml.patch # follow the reverted patch to use nixpkgs's hotkey_manager_linux
  ];

  flutterBuildFlags = [ "--dart-define=APP_ENV=stable" ];

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    keybinder3
    libayatana-appindicator
  ];

  preBuild = ''
    mkdir -p libclash/linux
    cp ${lib.getExe finalAttrs.passthru.core} libclash/linux/BettboxCore
  '';

  postInstall = ''
    install -Dm644 assets/images/icon.png $out/share/icons/hicolor/1024x1024/apps/bettbox.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/bettbox/lib
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "bettbox";
      desktopName = "Bettbox";
      exec = "bettbox %U";
      terminal = false;
      type = "Application";
      icon = "bettbox";
      startupNotify = true;
      startupWMClass = "com.appshub.bettbox";
      comment = "Another Better Mihomo Client";
      categories = [ "Network" ];
      keywords = [
        "Bettbox"
        "Clash"
        "ClashMeta"
        "Mihomo"
        "Proxy"
      ];
    })
  ];

  passthru = {
    core = buildGoModule {
      pname = "bettbox-core";
      inherit (finalAttrs) version src;

      vendorHash = "sha256-nzQgr149/R8U9v0oDRwDN/D9iQ7Lr4dQrFWq/CShcpQ=";
      modRoot = "core";
      env.CGO_ENABLED = 0;
      ldflags = [
        "-s"
        "-w"
      ];
      tags = [ "with_gvisor" ];
      subPackages = [ "." ];
      meta = finalAttrs.meta // {
        description = "Core for Bettbox";
        mainProgram = "core";
      };
    };
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--subpackage"
          "core"
          "--use-github-releases"
        ];
      })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "bettbox.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Another Better Mihomo Client, based on FlClash";
    homepage = "https://github.com/appshubcc/Bettbox";
    changelog = "https://github.com/appshubcc/Bettbox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "Bettbox";
    platforms = lib.platforms.linux;
  };
})
