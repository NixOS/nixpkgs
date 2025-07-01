{
  lib,
  fetchzip,
  fetchFromGitHub,
  fetchpatch,
  imagemagick,
  libgbm,
  libdrm,
  flutter332,
  pulseaudio,
  makeDesktopItem,
  olm,

  targetFlutterPlatform ? "linux",
}:

let
  libwebrtcRpath = lib.makeLibraryPath [
    libgbm
    libdrm
  ];
  pubspecLock = lib.importJSON ./pubspec.lock.json;
in
flutter332.buildFlutterApplication (
  rec {
    pname = "fluffychat-${targetFlutterPlatform}";
    version = "1.27.0";

    src = fetchFromGitHub {
      owner = "krille-chan";
      repo = "fluffychat";
      tag = "v${version}";
      hash = "sha256-kt4VpegxcZ+d0NIKan2A0AUqFLdYNcU9HY/4zyd2eSU=";
    };

    # https://github.com/krille-chan/fluffychat/pull/1965
    patches = [
      (fetchpatch {
        name = "fix_compilation_mxc_image.patch";
        url = "https://github.com/krille-chan/fluffychat/commit/e1ec87d3aaae00eb030bcfda28ec8f247e2c3346.patch";
        hash = "sha256-/cd3geNVPifAC7iTcx8V1l2WY9Y/mEw+VPl2B4HSJKY=";
      })
    ];

    inherit pubspecLock;

    gitHashes = {
      flutter_secure_storage_linux = "sha256-cFNHW7dAaX8BV7arwbn68GgkkBeiAgPfhMOAFSJWlyY=";
      flutter_web_auth_2 = "sha256-3aci73SP8eXg6++IQTQoyS+erUUuSiuXymvR32sxHFw=";
      flutter_typeahead = "sha256-ZGXbbEeSddrdZOHcXE47h3Yu3w6oV7q+ZnO6GyW7Zg8=";
    };

    inherit targetFlutterPlatform;

    meta = {
      description = "Chat with your friends (matrix client)";
      homepage = "https://fluffychat.im/";
      license = lib.licenses.agpl3Plus;
      mainProgram = "fluffychat";
      maintainers = with lib.maintainers; [
        mkg20001
        tebriel
        aleksana
      ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      inherit (olm.meta) knownVulnerabilities;
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [ imagemagick ];

    runtimeDependencies = [ pulseaudio ];

    env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

    desktopItem = makeDesktopItem {
      name = "Fluffychat";
      exec = "fluffychat";
      icon = "fluffychat";
      desktopName = "Fluffychat";
      genericName = "Chat with your friends (matrix client)";
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
      ];
    };

    postInstall = ''
      FAV=$out/app/fluffychat-linux/data/flutter_assets/assets/favicon.png
      ICO=$out/share/icons

      install -D $FAV $ICO/fluffychat.png
      mkdir $out/share/applications
      cp $desktopItem/share/applications/*.desktop $out/share/applications
      for size in 24 32 42 64 128 256 512; do
        D=$ICO/hicolor/''${s}x''${s}/apps
        mkdir -p $D
        magick $FAV -resize ''${size}x''${size} $D/fluffychat.png
      done

      patchelf --add-rpath ${libwebrtcRpath} $out/app/fluffychat-linux/lib/libwebrtc.so
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    prePatch =
      # https://github.com/krille-chan/fluffychat/blob/v1.17.1/scripts/prepare-web.sh
      let
        # Use Olm 1.3.2, the oldest version, for FluffyChat 1.14.1 which depends on olm_flutter 1.2.0.
        olmVersion = pubspecLock.packages.flutter_olm.version;
        olmJs = fetchzip {
          url = "https://github.com/famedly/olm/releases/download/v${olmVersion}/olm.zip";
          stripRoot = false;
          hash = "sha256-Vl3Cp2OaYzM5CPOOtTHtUb1W48VXePzOV6FeiIzyD1Y=";
        };
      in
      ''
        rm -r assets/js/package
        cp -r '${olmJs}/javascript' assets/js/package
      '';
  }
)
