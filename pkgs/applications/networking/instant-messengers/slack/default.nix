{ stdenv, fetchurl, dpkg
, alsaLib, atk, cairo, cups, dbus, expat, fontconfig, freetype, glib, gnome
, libnotify, nspr, nss, systemd, xorg }:

let

  version = "2.1.2";

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
    stdenv.cc.cc
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
    xorg.libXScrnSaver
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://slack-ssb-updates.global.ssl.fastly.net/linux_releases/slack-desktop-${version}-amd64.deb";
        sha256 = "0bmz9d0p6676lzl4qxy6xmcampr2ilkc0mhh67860kcxjaz6sms6";
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
    rm -rf $out/usr $out/share/lintian

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
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/
  '';

  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
