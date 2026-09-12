{
  lib,
  stdenv,
  fetchFromGitea,
  fetchzip,
  imagemagick,
  libgbm,
  libdrm,
  flutter344,
  pulseaudio,
  webkitgtk_4_1,
  makeDesktopItem,
  pkg-config,
  gst_all_1,
  keybinder3,
  libsecret,
  sqlcipher,
  openssl,
  mpv,
  libunwind,
  libpulseaudio,
  patchelf,
  copyDesktopItems,
  makeWrapper,
  nix-update-script,

  callPackage,
  # A web version will be prepared later
  #vodozemac-wasm ? callPackage ./vodozemac-wasm.nix { flutter = flutter341; },
  targetFlutterPlatform ? "linux",
}:
let
  version = "26.4.8";
  libwebrtcRpath = lib.makeLibraryPath [ libgbm libdrm ];
  libwebrtc = fetchzip {
    url = "https://github.com/webrtc-sdk/libwebrtc/releases/download/libwebrtc.m144.7559.09/libwebrtc-linux-x64-release.zip";
    sha256 = "sha256-uzS07voCGM1zs663UalYpb8pWiYpkrKMxKt/wB4rcB4=";
  };
in
flutter344.buildFlutterApplication (
  finalAttrs:
  {
    pname = "extera-next";
    inherit version;
    strictDeps = true;

    src = fetchFromGitea {
      domain = "source.extera.xyz";
      owner = "Extera";
      repo = "Extera";
      tag = "v${version}";
      sha256 = "sha256-iRqmPRuQfY3ZoqFQSY6aJwgadPwe9ZmUCETun6ANcCQ=";
    };
    gitHashes = {
      "android_system_font" = "sha256-mzbZ+joDw9E0PTFwqehiynMcWxAG5W5H+BZrWbpovBg=";
      "flutter_typeahead" = "sha256-ZGXbbEeSddrdZOHcXE47h3Yu3w6oV7q+ZnO6GyW7Zg8=";
      "matrix" = "sha256-gotYLzBbd2umF8A9nvusX536cwv5Suardx3eV2JSnqQ=";
    };

    patches = [
      ./fix-pubspec.patch
    ];

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    inherit targetFlutterPlatform;

    flutterBuildFlags = [
      "--enable-experiment=dot-shorthands"
    ];

    meta = {
      description = "A feature-rich [matrix] client made in Flutter";
      homepage = "https://extera.xyz/";
      license = lib.licenses.agpl3Plus;
      maintainers = with lib.maintainers; [ mate-linux ];
      badPlatforms = lib.platforms.darwin;
      platforms = lib.platforms.linux;
    }
    // lib.optionalAttrs (targetFlutterPlatform == "linux") {
      mainProgram = "extera-next";
    };
    passthru = {
      updateScript = nix-update-script { };
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [
      pkg-config
      imagemagick
      patchelf
      copyDesktopItems
      makeWrapper
    ];

    buildInputs = [
      webkitgtk_4_1
      libsecret
      keybinder3
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      sqlcipher
      openssl
      mpv
      libunwind
      libpulseaudio
    ];

    runtimeDependencies = [
      pulseaudio
    ];

    env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

    desktopItems = [
      (makeDesktopItem {
        name = "extera-next";
        exec = "extera-next";
        icon = "extera-next";
        desktopName = "Extera Next";
        genericName = "A feature-rich [matrix] client made in Flutter";
        categories = [
          "Chat"
          "Network"
          "InstantMessaging"
        ];
        startupWMClass = "extera-next";
      })
    ];

    customSourceBuilders = {
      flutter_webrtc =
        { version, src, ... }:
        stdenv.mkDerivation {
          pname = "flutter_webrtc";
          inherit version src;
          inherit (src) passthru;

          postPatch = ''
            mkdir -p third_party
            ln -s ${libwebrtc} third_party/libwebrtc

            mkdir -p third_party/downloads
            touch third_party/downloads/libwebrtc-linux-x64-release.zip
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r ./* $out/
            runHook postInstall
          '';
        };
    };

    postInstall = ''
      FAV=$out/app/extera-next/data/flutter_assets/assets/favicon.png

      for size in 24 32 42 64 128 256 512; do
        D=$out/share/icons/hicolor/''${size}x''${size}/apps
        mkdir -p $D
        magick $FAV -resize ''${size}x''${size} $D/extera-next.png
      done

      # Place libsqlcipher next to the app so Dart FFI can find it via
      # LD_LIBRARY_PATH. We deliberately do NOT create a libsqlite3.so symlink —
      # it would clash with the system libsqlite3.so pulled in by WebKitGTK.
      mkdir -p $out/app/extera-next/lib
      ln -s ${lib.getLib sqlcipher}/lib/libsqlcipher.so.0 $out/app/extera-next/lib/libsqlcipher.so
      ln -s ${lib.getLib sqlcipher}/lib/libsqlcipher.so.0 $out/app/extera-next/lib/libsqlcipher.so.0

      patchelf --add-rpath ${libwebrtcRpath} $out/app/extera-next/lib/libwebrtc.so

      # Create a shell wrapper with LD_PRELOAD to work around a sqlite/sqlcipher
      # symbol clash.
      #
      # PROBLEM: WebKitGTK transitively loads the system libsqlite3.so (via
      # libtinysparql → tracker). The sqlite3_* symbols in stock SQLite and in
      # SQLCipher share the same names but have different ABIs — SQLCipher stores
      # extended state in the global sqlite3Config struct. When Dart FFI opens
      # libsqlcipher.so, the dynamic linker resolves sqlite3_* globally, so
      # SQLCipher's internal calls end up dispatched into the already-loaded stock
      # SQLite. As a result, sqlite3_initialize() segfaults on a NULL xMutexAlloc
      # pointer inside sqlite3Config.
      #
      # SOLUTION: LD_PRELOAD ensures SQLCipher is loaded FIRST, so its symbols win
      # during resolution. WebKit's SQLite then loads afterwards and coexists in
      # the same process without interfering with Dart.

      cat > $out/bin/extera-next <<EOF
      #!${stdenv.shell}
      export LD_PRELOAD="$out/app/extera-next/lib/libsqlcipher.so.0\''${LD_PRELOAD:+:\$LD_PRELOAD}"

      if [ -n "\$LD_LIBRARY_PATH" ]; then
        export LD_LIBRARY_PATH="$out/app/extera-next/lib:\$LD_LIBRARY_PATH"
      else
        export LD_LIBRARY_PATH="$out/app/extera-next/lib"
      fi
      exec $out/bin/extera_next "\$@"
      EOF
      chmod +x $out/bin/extera-next
    '';

  }
)
