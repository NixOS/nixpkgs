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
  runtimeLibs = lib.makeLibraryPath [ libudev0-shim ];
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
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/streamlink/${basename}/releases/download/v${version}/${basename}-v${version}-${arch}.tar.gz";
    sha256 =
      if arch == "linux64"
      then
        "0y96nziavvpdvrpn58p6a175kaa8cgadp19rnbm250x9cypn1d9y"
      else
        "0sfmhqf55w7wavqy4idsqpkf5p7l8sapjxap6xvyzpz4z5z6xr7y";
  };

  nativeBuildInputs = with xorg; [
    at-spi2-core
    atk
    alsa-lib
    autoPatchelfHook
    cairo
    cups.lib
    dbus.daemon.lib
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
    license = licenses.mit;
    maintainers = with maintainers; [ rileyinman ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
