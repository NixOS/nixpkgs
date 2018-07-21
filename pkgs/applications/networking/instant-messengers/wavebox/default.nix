{ stdenv, fetchurl, makeDesktopItem, makeWrapper, autoPatchelfHook
, xorg, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig, gtk2, gtk3
, gnome3, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify, xdg_utils }:

with stdenv.lib;

let
  bits = "x86_64";

  version = "3.14.10";

  desktopItem = makeDesktopItem rec {
    name = "Wavebox";
    exec = name;
    icon = "wavebox";
    desktopName = name;
    genericName = name;
    categories = "Network;";
  };
in stdenv.mkDerivation rec {
  name = "wavebox-${version}";
  src = fetchurl {
    url = "https://github.com/wavebox/waveboxapp/releases/download/v${version}/Wavebox_${replaceStrings ["."] ["_"] (toString version)}_linux_${bits}.tar.gz";
    sha256 = "06ce349f561c6122b2d326e9a1363fb358e263c81a7d1d08723ec567235bbd74";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver
  ]) ++ [
    gtk2 gtk3 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome3.gconf nss nspr alsaLib cups expat stdenv.cc.cc
  ];

  runtimeDependencies = [ udev.lib libnotify ];

  installPhase = ''
    mkdir -p $out/bin $out/opt/wavebox
    cp -r * $out/opt/wavebox
    ln -s $out/opt/wavebox/Wavebox-linux-x64/Wavebox $out/bin/

    # provide desktop item and icon
    mkdir -p $out/share/applications $out/share/pixmaps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s $out/opt/wavebox/Wavebox-linux-x64/wavebox_icon.png $out/share/pixmaps/wavebox.png
  '';

  postFixup = ''
    paxmark m $out/opt/wavebox/Wavebox-linux-x64/Wavebox
    wrapProgram $out/opt/wavebox/Wavebox-linux-x64/Wavebox --prefix PATH : ${xdg_utils}/bin
  '';

  meta = with stdenv.lib; {
    description = "Wavebox messaging application";
    homepage = https://wavebox.io;
    license = licenses.mpl20;
    platforms = ["x86_64-linux"];
    hydraPlatforms = [];
  };
}
