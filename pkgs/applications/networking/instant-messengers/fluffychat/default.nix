{ lib
, fetchFromGitLab
, flutter
, olm
, imagemagick
, makeDesktopItem
}:

flutter.mkFlutterApp rec {
  pname = "fluffychat";
  version = "1.2.0";

  vendorHash = "sha256-j5opwEFifa+DMG7Uziv4SWEPVokD6OSq8mSIr0AdDL0=";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "fluffychat";
    rev = "v${version}";
    hash = "sha256-PJH3jMQc6u9R6Snn+9rNN8t+8kt6l3Xt7zKPbpqj13E=";
  };

  desktopItem = makeDesktopItem {
    name = "Fluffychat";
    exec = "@out@/bin/fluffychat";
    icon = "fluffychat";
    desktopName = "Fluffychat";
    genericName = "Chat with your friends (matrix client)";
    categories = [ "Chat" "Network" "InstantMessaging" ];
  };

  buildInputs = [
    olm
  ];

  nativeBuildInputs = [
    imagemagick
  ];

  flutterExtraFetchCommands = ''
    M=$(echo $TMP/.pub-cache/hosted/pub.dartlang.org/matrix-*)
    sed -i $M/scripts/prepare.sh \
      -e "s|/usr/lib/x86_64-linux-gnu/libolm.so.3|/bin/sh|g"  \
      -e "s|if which flutter >/dev/null; then|exit; if which flutter >/dev/null; then|g"

    pushd $M
    bash scripts/prepare.sh
    popd
  '';

  # replace olm dummy path
  postConfigure = ''
    M=$(echo $depsFolder/.pub-cache/hosted/pub.dartlang.org/matrix-*)
    ln -sf ${olm}/lib/libolm.so.3 $M/ffi/olm/libolm.so
  '';

  postInstall = ''
    FAV=$out/app/data/flutter_assets/assets/favicon.png
    ICO=$out/share/icons

    install -D $FAV $ICO/fluffychat.png
    mkdir $out/share/applications
    cp $desktopItem/share/applications/*.desktop $out/share/applications

    for s in 24 32 42 64 128 256 512; do
      D=$ICO/hicolor/''${s}x''${s}/apps
      mkdir -p $D
      convert $FAV -resize ''${s}x''${s} $D/fluffychat.png
    done

    substituteInPlace $out/share/applications/*.desktop \
      --subst-var out
  '';

  meta = with lib; {
    description = "Chat with your friends (matrix client)";
    homepage = "https://fluffychat.im/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
