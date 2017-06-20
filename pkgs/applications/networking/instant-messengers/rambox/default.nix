{ stdenv, fetchurl, makeDesktopItem
, xorg, gtk2, atk, glib, pango, gdk_pixbuf, cairo, freetype, fontconfig
, gnome2, dbus, nss, nspr, alsaLib, cups, expat, udev, libnotify }:

let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  version = "0.5.9";

  myIcon = fetchurl {
    url = "https://raw.githubusercontent.com/saenzramiro/rambox/9e4444e6297dd35743b79fe23f8d451a104028d5/resources/Icon.png";
    sha256 = "0r00l4r5mlbgn689i3rp6ks11fgs4h2flvrlggvm2qdd974d1x0b";
  };
  desktopItem = makeDesktopItem rec {
    name = "Rambox";
    exec = "rambox";
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
      "0wx1cj3h1h28lhvl8ysmvr2wxq39lklk37361i598vph2pvnibi0" else
      "1dqjd5rmml63h3y43n1r68il3pn8zwy0wwr0866cnpizsbis96fy";
  };

  # don't remove runtime deps
  dontPatchELF = true;

  deps = (with xorg; [
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes
    libXrender libX11 libXtst libXScrnSaver libxcb
  ]) ++ [
    gtk2 atk glib pango gdk_pixbuf cairo freetype fontconfig dbus
    gnome2.GConf nss nspr alsaLib cups expat stdenv.cc.cc
  # runtime deps
  ] ++ [
    udev libnotify
  ];

  installPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" rambox
    patchelf --set-rpath "$out/opt/rambox:${stdenv.lib.makeLibraryPath deps}" rambox

    mkdir -p $out/bin $out/opt/rambox
    cp -r * $out/opt/rambox
    ln -s $out/opt/rambox/rambox $out/bin

    # provide desktop item
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  postFixup = ''
    paxmark m $out/opt/rambox/rambox
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
