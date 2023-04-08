{ lib
, stdenv
, fetchzip
, imagemagick
, autoPatchelfHook
, gtk3
, libsecret
, jsoncpp
, wrapGAppsHook
, makeDesktopItem
}:

let
  version = "1.10.0";
  # map of nix platform -> expected url platform
  platformMap = {
    x86_64-linux = "linux-x86";
    aarch64-linux = "linux-arm64";
  };
in
stdenv.mkDerivation {
  inherit version;
  name = "fluffychat";

  src = fetchzip {
    url = "https://gitlab.com/api/v4/projects/16112282/packages/generic/fluffychat/${version}/fluffychat-${platformMap.${stdenv.hostPlatform.system}}.tar.gz";
    stripRoot = false;
    sha256 = "sha256-SbzTEMeJRFEUN0nZF9hL0UEzTWl1VtHVPIx/AGgQvM8=";
  };

  desktopItem = makeDesktopItem {
    name = "Fluffychat";
    exec = "@out@/bin/fluffychat";
    icon = "fluffychat";
    desktopName = "Fluffychat";
    genericName = "Chat with your friends (matrix client)";
    categories = [ "Chat" "Network" "InstantMessaging" ];
  };

  buildInputs = [ gtk3 libsecret jsoncpp ];
  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook imagemagick ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    mv * $out/share

    ln -s $out/share/fluffychat $out/bin/fluffychat

    FAV=$out/share/data/flutter_assets/assets/favicon.png
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
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
