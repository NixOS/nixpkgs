{ lib
, fetchFromGitLab
, imagemagick
, flutter
, makeDesktopItem
, gnome
}:

flutter.buildFlutterApplication rec {
  version = "1.12.1";
  name = "fluffychat";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "fluffychat";
    rev = "v${version}";
    hash = "sha256-F4oVscw5L8iQZtz5K+yo4tlPYYv1wfs88oyq5Uds20I=";
  };

  depsListFile = ./deps.json;
  vendorHash = "sha256-u0cQ5ejyxhw4du3jXRB8oWsAlMtbw5nX+SMUUCuwklE=";

  desktopItem = makeDesktopItem {
    name = "Fluffychat";
    exec = "@out@/bin/fluffychat";
    icon = "fluffychat";
    desktopName = "Fluffychat";
    genericName = "Chat with your friends (matrix client)";
    categories = [ "Chat" "Network" "InstantMessaging" ];
  };

  nativeBuildInputs = [ imagemagick ];
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
  '';

  meta = with lib; {
    description = "Chat with your friends (matrix client)";
    homepage = "https://fluffychat.im/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mkg20001 gilice ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
