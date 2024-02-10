{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, alsa-lib
, at-spi2-atk
, atk
, cairo
, cups
, dbus
, gcc-unwrapped
, gdk-pixbuf
, glib
, gtk3
, libdrm
, libnotify
, libpulseaudio
, libxkbcommon
, mesa
, nss
, udev
, xorg
}:

stdenv.mkDerivation rec {
  pname = "teamspeak5-client";
  version = "5.0.0-beta77";

  src = fetchurl {
    # check https://teamspeak.com/en/downloads/#ts5 for version and checksum
    url = "https://files.teamspeak-services.com/pre_releases/client/${version}/teamspeak-client.tar.gz";
    sha256 = "6f3bf97b120d3c799cefc90c448e45836708a826d7caa07ad32b5c868eb9181b";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups.lib
    dbus
    gcc-unwrapped.lib
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libnotify
    libpulseaudio
    libxkbcommon
    mesa.drivers
    nss
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXdamage
    xorg.libXfixes
    xorg.libxshmfence
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "TeamSpeak";
      exec = "TeamSpeak";
      icon = pname;
      desktopName = pname;
      comment = "TeamSpeak Voice Communication Client";
      categories = ["Audio" "AudioVideo" "Chat" "Network"];
    })
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/icons/hicolor/64x64/apps/

    cp -a * $out/share/${pname}
    cp logo-256.png $out/share/icons/hicolor/64x64/apps/${pname}.png

    makeWrapper $out/share/${pname}/TeamSpeak $out/bin/TeamSpeak \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ udev ]}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The TeamSpeak voice communication tool (beta version)";
    homepage = "https://teamspeak.com/";
    license = {
      fullName = "Teamspeak client license";
      url = "https://www.teamspeak.com/en/privacy-and-terms/";
      free = false;
    };
    maintainers = with maintainers; [ jojosch ];
    platforms = [ "x86_64-linux" ];
  };
}
