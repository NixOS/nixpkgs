{ lib
, stdenv
, fetchFromGitLab
, flutter
, mesa
, olm
, fribidi
, imagemagick
, makeDesktopItem
}:

flutter.mkFlutterApp rec {
  pname = "fluffychat";
  version = "1.8.0";

  vendorHash = {
    "x86_64-linux" = "sha256-MnqgBCrTgq46AavzZ53G7Wmw/5yCgQlxOSpzPnphUUk=";
    "aarch64-linux" = "sha256-SRRVw98Pqa9GBpnSv/8oKad5nUGB+UCSvW3isuVhfuA=";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "fluffychat";
    rev = "v${version}";
    hash = "sha256-i3kG4dXGzeOsQM+ZDI3ENrV7NyXpJOC8M+pS77lwwac=";
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
    mesa
    olm
  ];

  nativeBuildInputs = [
    imagemagick
  ];

  NIX_CFLAGS_COMPILE = "-I${fribidi}/include/fribidi";

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
    maintainers = with maintainers; [ mkg20001 nickcao ];
    platforms = platforms.linux;
  };
}
