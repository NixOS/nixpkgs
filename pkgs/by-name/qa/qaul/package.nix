{
  lib,
  stdenv,
  flutter338,
  qauld,
  gst_all_1,
  libayatana-appindicator,
  libGL,
  addDriverRunpath,
  copyDesktopItems,
  makeDesktopItem,
  _experimental-update-script-combinators,
  nix-update-script,
  runCommand,
  yq-go,
}:

let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
flutter338.buildFlutterApplication (finalAttrs: {
  pname = "qaul";
  inherit (qauld) version src;
  __structuredAttrs = true;
  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/qaul_ui";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # src postFetch rewrites the FFI open to bare liblibqaul.so (FOD is
  # platform-agnostic). Point at the host shared-lib name here.
  postPatch = ''
    substituteInPlace packages/qaul_rpc/lib/src/libqaul/ffi.dart \
      --replace-fail \
      "DynamicLibrary.open('liblibqaul.so')" \
      "DynamicLibrary.open('liblibqaul${libExt}')"
  '';

  # Under __structuredAttrs, passAsFile leaves pubspecLockFilePath empty.
  preConfigure = ''
    export pubspecLockFilePath=${./pubspec.lock.json}
  '';

  # liblibqaul via qauld; libGL + opengl-driver for Flutter/epoxy.
  runtimeDependencies = [
    qauld
    libGL
  ];

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ addDriverRunpath.driverLink ]}
  '';

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libayatana-appindicator
  ];

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "qaul";
      exec = "qaul";
      icon = "qaul";
      desktopName = "qaul";
      genericName = "Internet-independent wireless mesh communication";
      categories = [
        "Network"
        "Chat"
        "InstantMessaging"
      ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/logo/icon_desktop.png \
      $out/share/icons/hicolor/256x256/apps/qaul.png
    install -Dm644 assets/logo/logo.svg \
      $out/share/icons/hicolor/scalable/apps/qaul.svg
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint \
            $src/qaul_ui/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "qaul.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Internet-independent wireless mesh communication app";
    homepage = "https://qaul.net";
    inherit (qauld.meta) changelog;
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
    mainProgram = "qaul";
    platforms = lib.platforms.unix;
  };
})
