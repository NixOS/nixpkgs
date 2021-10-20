{ lib, stdenv, fetchurl, dpkg, alsa-lib, atk, cairo, cups, dbus, expat, fontconfig
, freetype, gdk-pixbuf, glib, gnome2, gtk2, nspr, nss, pango, udev, xorg }:
let
  fullPath = lib.makeLibraryPath [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk2
    nspr
    nss
    pango
    udev
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ] + ":${stdenv.cc.cc.lib}/lib64";
in
stdenv.mkDerivation rec {
  version = "1.17.82";
  pname = "stride";

  src = fetchurl {
    url = "https://packages.atlassian.com/stride-apt-client/pool/stride_${version}_amd64.deb";
    sha256 = "0lx61gdhw0kv4f9fwbfg69yq52dsp4db7c4li25d6wn11qanzqhy";
  };

  dontBuild = true;
  dontFixup = true;

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase =''
    mkdir "$out"
    mv usr/* "$out/"
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${fullPath}:\$ORIGIN" \
      "$out/bin/stride"
  '';

  meta = with lib; {
    description = "Desktop client for Atlassian Stride";
    homepage = "https://www.stride.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ puffnfresh ];
  };
}
