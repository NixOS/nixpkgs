{ stdenv, fetchurl, dpkg
, alsaLib, atk, cairo, cups, curl, dbus, expat, fontconfig, freetype, glib, gnome2
, libnotify, nspr, nss, systemd, xorg }:

let

  version = "2.5.2";

  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    gnome2.GConf
    gnome2.gdk_pixbuf
    gnome2.gtk
    gnome2.pango
    libnotify
    nspr
    nss
    stdenv.cc.cc
    systemd

    xorg.libxkbfile
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
        url = "https://downloads.slack-edge.com/linux_releases/slack-desktop-${version}-amd64.deb";
        sha256 = "0mg8js18lnnwyvqksrhpym7d04bin16bh7sdmxbm36iijb9ajxmi";
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
    rm -rf $out/etc $out/usr $out/share/lintian

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
