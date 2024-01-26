{ lib
, fetchzip
, fetchFromGitHub
, imagemagick
, mesa
, libdrm
, flutter
, pulseaudio
, makeDesktopItem
, gnome

, targetFlutterPlatform ? "linux"
}:

let
  libwebrtcRpath = lib.makeLibraryPath [ mesa libdrm ];
  pubspecLock = lib.importJSON ./pubspec.lock.json;
in
flutter.buildFlutterApplication (rec {
  pname = "fluffychat-${targetFlutterPlatform}";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "krille-chan";
    repo = "fluffychat";
    rev = "refs/tags/v${version}";
    hash = "sha256-SCZtdmpUaCwORIJgT9lQO/It+WSzkhBOd6liLzPBerU=";
  };

  inherit pubspecLock;

  gitHashes = {
    keyboard_shortcuts = "sha256-U74kRujftHPvpMOIqVT0Ph+wi1ocnxNxIFA1krft4Os=";
    wakelock_windows = "sha256-Dfwe3dSScD/6kvkP67notcbb+EgTQ3kEYcH7wpra2dI=";
  };

  inherit targetFlutterPlatform;

  meta = with lib; {
    description = "Chat with your friends (matrix client)";
    homepage = "https://fluffychat.im/";
    license = licenses.agpl3Plus;
    mainProgram = "fluffychat";
    maintainers = with maintainers; [ mkg20001 gilice ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ sourceTypes.fromSource ];
  };
} // lib.optionalAttrs (targetFlutterPlatform == "linux") {
  nativeBuildInputs = [ imagemagick ];

  runtimeDependencies = [ pulseaudio ];

  extraWrapProgramArgs = "--prefix PATH : ${gnome.zenity}/bin";

  env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

  desktopItem = makeDesktopItem {
    name = "Fluffychat";
    exec = "fluffychat";
    icon = "fluffychat";
    desktopName = "Fluffychat";
    genericName = "Chat with your friends (matrix client)";
    categories = [ "Chat" "Network" "InstantMessaging" ];
  };

  postInstall = ''
    FAV=$out/app/data/flutter_assets/assets/favicon.png
    ICO=$out/share/icons

    install -D $FAV $ICO/fluffychat.png
    mkdir $out/share/applications
    cp $desktopItem/share/applications/*.desktop $out/share/applications
    for size in 24 32 42 64 128 256 512; do
      D=$ICO/hicolor/''${s}x''${s}/apps
      mkdir -p $D
      convert $FAV -resize ''${size}x''${size} $D/fluffychat.png
    done

    patchelf --add-rpath ${libwebrtcRpath} $out/app/lib/libwebrtc.so
  '';
} // lib.optionalAttrs (targetFlutterPlatform == "web") {
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
})
