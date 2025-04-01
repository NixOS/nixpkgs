{
  autoPatchelfHook,
  fetchurl,
  lib,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  wrapGAppsHook3,
  at-spi2-core,
  atk,
  alsa-lib,
  cairo,
  cups,
  dbus,
  expat,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  pango,
  gtk3-x11,
  libudev0-shim,
  libuuid,
  mesa,
  nss,
  nspr,
  xorg,
  streamlink,
}:
let
  basename = "streamlink-twitch-gui";
  runtimeLibs = lib.makeLibraryPath [
    gtk3-x11
    libudev0-shim
  ];
  runtimeBins = lib.makeBinPath [ streamlink ];

in
stdenv.mkDerivation rec {
  pname = "${basename}-bin";
  version = "2.4.1";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/streamlink/${basename}/releases/download/v${version}/${basename}-v${version}-linux64.tar.gz";
        hash = "sha256-uzD61Q1XIthAwoJHb0H4sTdYkUj0qGeGs1h0XFeV03E=";
      };
      i686-linux = fetchurl {
        url = "https://github.com/streamlink/${basename}/releases/download/v${version}/${basename}-v${version}-linux32.tar.gz";
        hash = "sha256-akJEd94PmH9YeBud+l5+5QpbnzXAD0jDBKJM4h/t2EA=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = with xorg; [
    at-spi2-core
    atk
    alsa-lib
    autoPatchelfHook
    cairo
    copyDesktopItems
    cups.lib
    dbus.lib
    expat
    gcc-unwrapped
    gdk-pixbuf
    glib
    pango
    gtk3-x11
    mesa
    nss
    nspr
    libuuid
    libX11
    libxcb
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [ streamlink ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt/${basename},share}

    # Install all files, remove unnecessary ones
    cp -a . $out/opt/${basename}/
    rm -r $out/opt/${basename}/{{add,remove}-menuitem.sh,credits.html,icons/}
    ln -s $out/opt/${basename}/${basename} $out/bin/
    for res in 16 32 48 64 128 256; do
      install -Dm644 \
        icons/icon-"$res".png \
        $out/share/icons/hicolor/"$res"x"$res"/apps/${basename}.png
    done
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "--no-version-check" \
      --prefix LD_LIBRARY_PATH : ${runtimeLibs} \
      --prefix PATH : ${runtimeBins}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = basename;
      exec = basename;
      icon = basename;
      desktopName = "Streamlink Twitch GUI";
      genericName = meta.description;
      categories = [
        "AudioVideo"
        "Network"
      ];
    })
  ];

  meta = with lib; {
    description = "Twitch.tv browser for Streamlink";
    longDescription = "Browse Twitch.tv and watch streams in your videoplayer of choice";
    homepage = "https://streamlink.github.io/streamlink-twitch-gui/";
    downloadPage = "https://github.com/streamlink/streamlink-twitch-gui/releases";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    mainProgram = "streamlink-twitch-gui";
    maintainers = with maintainers; [ rileyinman ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
