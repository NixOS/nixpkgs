{
  pname,
  version,
  meta,

  lib,
  fetchFromGitHub,
  flutter341,
  replaceVars,
  rustPlatform,
  stdenvNoCC,

  # nativeBuildInputs
  copyDesktopItems,
  makeDesktopItem,

  # buildInputs
  libayatana-appindicator,

  # passthru
  nixosTests,
}:
flutter341.buildFlutterApplication (finalAttrs: {
  inherit pname version;

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "localsend";
    repo = "localsend";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AmQVXGMVKLTOZ0HMi05ba/y4TmB56NlNvtGaKYvqt4o=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    device_apps = "sha256-oreTBOYh4J2N4HhY2gxNwwxfl1OSAZRH1GOeVrH8LG8=";
    pasteboard = "sha256-lJA5OWoAHfxORqWMglKzhsL1IFr9YcdAQP/NVOLYB4o=";
    permission_handler_windows = "sha256-+TP3neqlQRZnW6BxHaXr2EbmdITIx1Yo7AEn5iwAhwM=";
  };

  postPatch = ''
    substituteInPlace lib/util/native/autostart_helper.dart \
      --replace-fail 'Exec=''${Platform.resolvedExecutable}' "Exec=localsend_app"
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [ libayatana-appindicator ];

  customSourceBuilders.rust_lib_localsend_app =
    { version, src, ... }:
    stdenvNoCC.mkDerivation (finalAttrs': {
      pname = "rust_lib_localsend_app";
      inherit version src;
      inherit (src) passthru;

      postPatch = ''
        pushd ${finalAttrs'.src.passthru.packageRoot}
        patch -p1 <${
          replaceVars ./no-cargokit.patch {
            inherit (finalAttrs.passthru) rustLib;
          }
        }
        popd
      '';

      installPhase = ''
        runHook preInstall
        cp -r . $out
        runHook postInstall
      '';
    });

  postInstall = ''
    for s in 32 128 256 512; do
      d=$out/share/icons/hicolor/''${s}x''${s}/apps
      mkdir -p $d
      cp assets/img/logo-''${s}.png $d/localsend.png
    done
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/localsend/lib
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "LocalSend";
      exec = "localsend_app %U";
      icon = "localsend";
      desktopName = "LocalSend";
      startupWMClass = "localsend_app";
      genericName = "An open source cross-platform alternative to AirDrop";
      categories = [
        "GTK"
        "FileTransfer"
        "Utility"
      ];
      keywords = [
        "Sharing"
        "LAN"
        "Files"
      ];
      startupNotify = true;
    })
  ];

  passthru = {
    rustLib = rustPlatform.buildRustPackage {
      pname = "${finalAttrs.pname}-rust-lib";
      inherit (finalAttrs) version src;
      cargoHash = "sha256-mdyWYfzS6YieY+dwQXREZJDo4PEKO5W9C3A3XGWoDKI=";
      buildAndTestSubdir = "packages/localsend_isolates/rust";
    };
    tests = { inherit (nixosTests) localsend; };
  };

  meta = meta // {
    mainProgram = "localsend_app";
    platforms = lib.platforms.linux;
  };
})
