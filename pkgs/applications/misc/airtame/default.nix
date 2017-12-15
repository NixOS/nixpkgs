{ stdenv, lib, makeDesktopItem, makeWrapper
, alsaLib, atk, cairo, cups, dbus, expat, fetchurl, fontconfig, freetype
, gdk_pixbuf, glib, gnome2, libXScrnSaver, nspr, nss, udev, xlibs
}:

stdenv.mkDerivation rec {
  pname = "airtame";
  version = "3.0.1";
  name = "${pname}-${version}";
  longName = "${pname}-application";

  src = fetchurl {
    url = "https://downloads.airtame.com/application/ga/lin_x64/releases/${longName}-${version}.tar.gz";
    sha256 = "1z5v9dwcvcmz190acm89kr4mngirha1v2jpvfzvisi0vidl2ba60";
  };

  nativeBuildInputs = [ makeWrapper ];

  desktopItem = makeDesktopItem rec {
    name = "airtame";
    exec = longName;
    comment = "Airtame Streaming Client";
    desktopName = "Airtame";
    icon = name;
    genericName = comment;
    categories = "Application;Network;";
  };

  installPhase = ''
    opt="$out/opt/airtame"
    mkdir -p "$opt"
    cp -R . "$opt"
    mkdir -p "$out/bin"
    ln -s "$opt/${longName}" "$out/bin/"
    ln -s "${udev.lib}/lib/libudev.so.1" "$opt/libudev.so.1"
    mkdir -p "$out/share"
    cp -r "${desktopItem}/share/applications" "$out/share/"
    mkdir -p "$out/share/icons"
    ln -s "$opt/icon.png" "$out/share/icons/airtame.png"
  '';

  preFixup = let
    libPath = lib.makeLibraryPath [
      alsaLib
      atk
      cairo
      cups
      dbus.lib
      expat
      fontconfig
      freetype
      gdk_pixbuf
      glib
      gnome2.GConf
      gnome2.gtk
      gnome2.pango
      nspr
      nss
      udev.lib
      stdenv.cc.cc.lib
      xlibs.libX11
      xlibs.libXScrnSaver
      xlibs.libXcomposite
      xlibs.libXcursor
      xlibs.libXdamage
      xlibs.libXext
      xlibs.libXfixes
      xlibs.libXi
      xlibs.libXrandr
      xlibs.libXrender
      xlibs.libXtst
      xlibs.libxcb
    ];
  in ''
    patchelf $opt/${longName} \
      --set-interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$opt:${libPath}"
  '';

  postFixup = ''
    wrapProgram $opt/${longName} \
      --set LD_LIBRARY_PATH "$opt/resources/app.asar.unpacked/streamer/vendor/airtame-core/lib:$opt/resources/app.asar.unpacked/encryption/out/lib" \
      --add-flags "--disable-gpu --enable-transparent-visuals"
  '';

  meta = with stdenv.lib; {
    homepage = https://airtame.com/download;
    description = "Wireless streaming client for Airtame devices";
    license = licenses.unfree;
    maintainers = with maintainers; [ thanegill ];
    platforms = platforms.linux;
  };
}
