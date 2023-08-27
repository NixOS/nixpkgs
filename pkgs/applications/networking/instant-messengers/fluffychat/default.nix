{ lib
, fetchFromGitHub
, imagemagick
, mesa
, libdrm
, flutter
, pulseaudio
, makeDesktopItem
, gnome
}:

let
  libwebrtcRpath = lib.makeLibraryPath [ mesa libdrm ];
in
flutter.buildFlutterApplication rec {
  pname = "fluffychat";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "krille-chan";
    repo = "fluffychat";
    rev = "refs/tags/v${version}";
    hash = "sha256-w29Nxs/d0b18jMvWnrRUjEGqY4jGtuEGodg+ncCAaVc=";
  };

  depsListFile = ./deps.json;
  vendorHash = "sha256-dkH+iI1KLsAJtSt6ndc3ZRBllZ9n21RNONqeeUzNQCE=";

  desktopItem = makeDesktopItem {
    name = "Fluffychat";
    exec = "@out@/bin/fluffychat";
    icon = "fluffychat";
    desktopName = "Fluffychat";
    genericName = "Chat with your friends (matrix client)";
    categories = [ "Chat" "Network" "InstantMessaging" ];
  };

  nativeBuildInputs = [ imagemagick ];
  runtimeDependencies = [ pulseaudio ];
  extraWrapProgramArgs = "--prefix PATH : ${gnome.zenity}/bin";
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
    substituteInPlace $out/share/applications/*.desktop \
      --subst-var out

    patchelf --add-rpath ${libwebrtcRpath} $out/app/lib/libwebrtc.so
  '';

  env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

  meta = with lib; {
    description = "Chat with your friends (matrix client)";
    homepage = "https://fluffychat.im/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mkg20001 gilice ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
