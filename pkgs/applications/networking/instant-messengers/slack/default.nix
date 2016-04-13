{ stdenv, fetchurl, dpkg
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, glib, gnome
, libnotify, nspr, nss, systemd, xorg }:

let

  version = "2.0.3";

  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    glib
    gnome.GConf
    gnome.gdk_pixbuf
    gnome.gtk
    gnome.pango
    libnotify
    nspr
    nss
    systemd

    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
  ] + ":${stdenv.cc.cc}/lib64";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/slack-desktop-${version}-amd64.deb";
        sha256 = "0pp8n1w9kmh3pph5kc6akdswl3z2lqwryjg9d267wgj62mslr3cg";
      }
    else
      throw "Slack is not supported on ${stdenv.system}";

in stdenv.mkDerivation {
  name = "slack-${version}";

  inherit src;

  buildInputs = [ dpkg ];
  unpackPhase = "true";
  buildCommand = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/usr

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/slack $file || true
    done

    # Fix the symlink
    rm $out/bin/slack
    ln -s $out/lib/slack/slack $out/bin/slack

    # Fix the desktop link
    substituteInPlace $out/share/applications/slack.desktop \
      --replace /usr/lib/slack/slack $out/lib/slack/slack
  '';

  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
