{ autoPatchelfHook
, fetchurl
, lib
, makeDesktopItem
, makeWrapper
, stdenv
, wrapGAppsHook
, at-spi2-core
, atk
, alsa-lib
, cairo
, cups
, dbus
, expat
, gcc-unwrapped
, gdk-pixbuf
, glib
, pango
, gtk3-x11
, libudev0-shim
, libuuid
, mesa
, nss
, nspr
, xorg
, streamlink
}:
let
  basename = "streamlink-twitch-gui";
  runtimeLibs = lib.makeLibraryPath [ gtk3-x11 libudev0-shim ];
  runtimeBins = lib.makeBinPath [ streamlink ];
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then
      "linux64"
    else
      "linux32";

in
stdenv.mkDerivation rec {
  pname = "${basename}-bin";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/streamlink/${basename}/releases/download/v${version}/${basename}-v${version}-${arch}.tar.gz";
    hash =
      if arch == "linux64"
      then
        "sha256-kfCGhIgKMI0siDqnmIHSMk6RMHFlW6uwVsW48aiRua0="
      else
        "sha256-+jgTpIYb4BPM7Ixmo+YUeOX5OlQlMaRVEXf3WzS2lAI=";
  };

  nativeBuildInputs = with xorg; [
    at-spi2-core
    atk
    alsa-lib
    autoPatchelfHook
    cairo
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
    wrapGAppsHook
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
    ln -s "$out/opt/${basename}/${basename}" $out/bin/
    cp -r "${desktopItem}/share/applications" $out/share/
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags "--no-version-check" \
      --prefix LD_LIBRARY_PATH : ${runtimeLibs} \
      --prefix PATH : ${runtimeBins}
    )
  '';

  desktopItem = makeDesktopItem {
    name = basename;
    exec = basename;
    icon = basename;
    desktopName = "Streamlink Twitch GUI";
    genericName = meta.description;
    categories = [ "AudioVideo" "Network" ];
  };

  meta = with lib; {
    description = "Twitch.tv browser for Streamlink";
    longDescription = "Browse Twitch.tv and watch streams in your videoplayer of choice";
    homepage = "https://streamlink.github.io/streamlink-twitch-gui/";
    downloadPage = "https://github.com/streamlink/streamlink-twitch-gui/releases";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ rileyinman ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
