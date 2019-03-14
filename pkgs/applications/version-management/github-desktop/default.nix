{ stdenv, autoPatchelfHook, alsaLib, atk, cairo, cups, dbus, dpkg
, expat, fontconfig, freetype, fetchurl, gnome3, gdk_pixbuf
, glib, gtk2, gtk3, libpulseaudio, makeWrapper, nspr, nss, pango
, udev, xorg
}:

let
  version = "1.6.0";

  deps = [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gnome3.GConf
    gdk_pixbuf
    glib
    gtk2
    gtk3
    libpulseaudio
    nspr
    nss
    pango
    stdenv.cc.cc
    udev
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
  ];

in

stdenv.mkDerivation {
  name = "github-desktop-${version}";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${version}-linux1/GitHubDesktop-linux-${version}-linux1.deb";
    sha256 = "08wi0y98smi1p9cmjifkj5ivswbqk2b3wm9jwy7b00djqc9lxgc8";
  };

  dontBuild = true;
  buildInputs = [ dpkg ];
  nativeBuildInputs = [ autoPatchelfHook ];
 
  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r ./opt/GitHub\ Desktop $out
  '';

  runtimeDependencies = [
    gnome3.gtk
  ];

  meta = {
    description = "Desktop client for GitHub";
    homepage = "https://github.com/desktop/desktop/issues/1525";
    license = stdenv.lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.ghuntley ];
  };
}
