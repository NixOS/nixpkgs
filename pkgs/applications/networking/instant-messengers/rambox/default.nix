{ stdenv, fetchurl, makeDesktopItem
, xorg, gtk2, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify }:

let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  version = "0.4.4";

  myIcon = fetchurl {
    url = "https://raw.githubusercontent.com/saenzramiro/rambox/9e4444e6297dd35743b79fe23f8d451a104028d5/resources/Icon.png";
    sha256 = "0r00l4r5mlbgn689i3rp6ks11fgs4h2flvrlggvm2qdd974d1x0b";
  };

  desktopItem = makeDesktopItem rec {
    name = "Rambox";
    exec = name;
    icon = myIcon;
    desktopName = name;
    genericName = "Rambox messenger";
    categories = "Network;";
  };
in stdenv.mkDerivation rec {
  name = "rambox-${version}";
  src = fetchurl {
    url = "https://github.com/saenzramiro/rambox/releases/download/${version}/Rambox-${version}-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "05xwabwij7fyifrypahcplymz46k01rzrwgp5gn79hh023w259i0" else
      "16j17rc8mld96mq1rxnwmxwfa2q5b44s40c56mwh34plqyn546l2";
  };

  phases = [ "unpackPhase" "installPhase" ];

  deps = with xorg; [
   gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
   libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
   libXrender libX11 libXtst libXScrnSaver gnome2.GConf nss nspr alsaLib
   cups expat stdenv.cc.cc

   udev libnotify
  ];

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" Rambox
    patchelf --set-rpath "$out/share/rambox:${stdenv.lib.makeLibraryPath deps}" Rambox

    mkdir -p $out/bin $out/share/rambox
    cp -r * $out/share/rambox
    ln -s $out/share/rambox/Rambox $out/bin

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = "Free and Open Source messaging and emailing app that combines common web applications into one";
    homepage = http://rambox.pro;
    license = licenses.mit;
    maintainers = [ stdenv.lib.maintainers.gnidorah ];
    platforms = ["i686-linux" "x86_64-linux"];
    hydraPlatforms = [];
  };
}
