{ autoPatchelfHook, fetchurl, lib, makeDesktopItem, makeWrapper, stdenv, wrapGAppsHook
, at-spi2-core, atk, alsaLib, cairo, cups, dbus, expat, gcc-unwrapped
, gdk-pixbuf, glib, pango, gtk3-x11, libudev0-shim, libuuid, nss, nspr, xorg
, streamlink }:

let
  basename = "streamlink-twitch-gui";
  runtimeLibs = lib.makeLibraryPath [ libudev0-shim ];
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux"
    then
      "linux64"
    else
      "linux32";

in
stdenv.mkDerivation rec {
  pname = "${basename}-bin";
  version = "1.10.0";

  src = fetchurl {
    url = "https://github.com/streamlink/${basename}/releases/download/v${version}/${basename}-v${version}-${arch}.tar.gz";
    sha256 =
      if arch == "linux64"
      then
        "17s9zbzj4pgz9mxxwjbp3788afkddc9s3p7xp28y5084z9wwzph2"
      else
        "1pww05hr48m6v0g1sz48g1c7p615lig3s12l21xgyz4gkjzmjy22";
  };

  nativeBuildInputs = with xorg; [
    at-spi2-core
    atk
    alsaLib
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
    mkdir -p $out/{bin,opt/${basename},share}

    # Install all files, remove unnecessary ones
    cp -a . $out/opt/${basename}/
    rm -r $out/opt/${basename}/{{add,remove}-menuitem.sh,credits.html,icons/}

    wrapProgram $out/opt/${basename}/${basename} --add-flags "--no-version-check" --prefix LD_LIBRARY_PATH : ${runtimeLibs}

    ln -s "$out/opt/${basename}/${basename}" $out/bin/
    ln -s "${desktopItem}/share/applications" $out/share/
  '';

  desktopItem = makeDesktopItem {
    name = basename;
    exec = basename;
    icon = basename;
    desktopName = "Streamlink Twitch GUI";
    genericName = meta.description;
    categories = "AudioVideo;Network;";
  };

  meta = with stdenv.lib; {
    description = "Twitch.tv browser for Streamlink";
    longDescription = "Browse Twitch.tv and watch streams in your videoplayer of choice";
    homepage = "https://streamlink.github.io/streamlink-twitch-gui/";
    downloadPage = https://github.com/streamlink/streamlink-twitch-gui/releases;
    license = licenses.mit;
    maintainers = with maintainers; [ rileyinman ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
