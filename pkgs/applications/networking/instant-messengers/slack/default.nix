{ theme ? null, stdenv, fetchurl, dpkg, makeWrapper , alsaLib, atk, cairo,
cups, curl, dbus, expat, fontconfig, freetype, glib , gnome2, gtk3, gdk_pixbuf,
libappindicator-gtk3, libnotify, libxcb, nspr, nss, pango , systemd, xorg,
at-spi2-atk, libuuid, nodePackages
}:

let

  version = "4.0.0";

  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
    at-spi2-atk
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
    gdk_pixbuf
    gtk3
    pango
    libnotify
    libxcb
    libappindicator-gtk3
    nspr
    nss
    stdenv.cc.cc
    systemd
    libuuid

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
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://downloads.slack-edge.com/linux_releases/slack-desktop-${version}-amd64.deb";
        sha256 = "911a4c05fb4f85181df13f013e82440b0d171862c9cb137dc19b6381d47bd57e";
      }
    else
      throw "Slack is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  name = "slack-${version}";

  inherit src;

  buildInputs = [
    dpkg
    gtk3  # needed for GSETTINGS_SCHEMAS_PATH
  ];

  nativeBuildInputs = [ makeWrapper nodePackages.asar ];

  dontUnpack = true;
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

    # Replace the broken bin/slack symlink with a startup wrapper
    rm $out/bin/slack
    makeWrapper $out/lib/slack/slack $out/bin/slack \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH

    # Fix the desktop link
    substituteInPlace $out/share/applications/slack.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/
  '' + stdenv.lib.optionalString (theme != null) ''
    asar extract $out/lib/slack/resources/app.asar $out/lib/slack/resources/app.asar.unpacked
    cat <<EOF >> $out/lib/slack/resources/app.asar.unpacked/dist/ssb-interop.bundle.js

    var fs = require('fs');
    document.addEventListener('DOMContentLoaded', function() {
      fs.readFile('${theme}/theme.css', 'utf8', function(err, css) {
        let s = document.createElement('style');
        s.type = 'text/css';
        s.innerHTML = css;
        document.head.appendChild(s);
      });
    });
    EOF
    asar pack $out/lib/slack/resources/app.asar.unpacked $out/lib/slack/resources/app.asar
  '';

  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = https://slack.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
