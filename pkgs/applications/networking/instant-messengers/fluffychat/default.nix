{ lib
, fetchFromGitLab
, flutter
, olm
, imagemagick
, jack2
, alsa-lib
, libpulseaudio
, fribidi
, libgcrypt
, libgpg-error
, makeDesktopItem
}:

flutter.mkFlutterApp rec {
  pname = "fluffychat";
  version = "1.6.1";

  vendorHash = "sha256-SelMRETFYZgTStV90gRoKhazu1NPbcSMO9mYebSQskQ=";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "fluffychat";
    rev = "v${version}";
    hash = "sha256-aBhhGyzNgwCWQ+zLanFJpQ2ibR+qI+ETRTWL0TzNHT4=";
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
    jack2
    alsa-lib
    libpulseaudio
    fribidi
    libgcrypt
    libgpg-error
  ];

  NIX_CFLAGS_COMPILE = "-I${fribidi}/include/fribidi";

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
