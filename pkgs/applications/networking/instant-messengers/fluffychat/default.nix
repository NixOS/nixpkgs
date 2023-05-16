{ lib
<<<<<<< HEAD
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
=======
, fetchFromGitLab
, imagemagick
, flutter37
, makeDesktopItem
}:

flutter37.buildFlutterApplication rec {
  version = "1.11.0";
  name = "fluffychat";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "fluffychat";
    rev = "v${version}";
    hash = "sha256-Z7BOGsirBVQxRJY4kmskCmPeZloc41/bf4/ExoO8VBk=";
  };

  depsListFile = ./deps.json;
  vendorHash = "sha256-axByNptbzGR7GQT4Gs2yaEyUCkCbI9RQNNOHN7CYd9A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  desktopItem = makeDesktopItem {
    name = "Fluffychat";
    exec = "@out@/bin/fluffychat";
    icon = "fluffychat";
    desktopName = "Fluffychat";
    genericName = "Chat with your friends (matrix client)";
    categories = [ "Chat" "Network" "InstantMessaging" ];
  };
<<<<<<< HEAD

  nativeBuildInputs = [ imagemagick ];
  runtimeDependencies = [ pulseaudio ];
  extraWrapProgramArgs = "--prefix PATH : ${gnome.zenity}/bin";
=======
  nativeBuildInputs = [ imagemagick ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

    patchelf --add-rpath ${libwebrtcRpath} $out/app/lib/libwebrtc.so
  '';

  env.NIX_LDFLAGS = "-rpath-link ${libwebrtcRpath}";

=======
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Chat with your friends (matrix client)";
    homepage = "https://fluffychat.im/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mkg20001 gilice ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
