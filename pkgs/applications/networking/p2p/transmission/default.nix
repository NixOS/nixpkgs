{ stdenv, fetchurl, pkgconfig, intltool, file, wrapGAppsHook
, openssl, curl, libevent, inotify-tools, systemd, zlib
, enableGTK3 ? false, gtk3, hicolor_icon_theme
}:

let
  version = "2.90";
in

with { inherit (stdenv.lib) optional optionals optionalString; };

stdenv.mkDerivation rec {
  name = "transmission-" + optionalString enableGTK3 "gtk-" + version;

  src = fetchurl {
    url = "https://transmission.cachefly.net/transmission-${version}.tar.xz";
    sha256 = "1lig7y9fhmv2ajgq1isj9wqgpcgignzlczs3dy95ahb8h6pqrzv9";
  };

  buildInputs = [ pkgconfig intltool file openssl curl libevent inotify-tools zlib ]
    ++ optionals enableGTK3 [ gtk3 wrapGAppsHook hicolor_icon_theme ]
    ++ optional stdenv.isLinux systemd;

  preConfigure = ''
    sed -i -e 's|/usr/bin/file|${file}/bin/file|g' configure
  '';

  configureFlags = [ "--with-systemd-daemon" ]
    ++ optional enableGTK3 "--with-gtk";

#  preFixup = optionalString enableGTK3 /* gsettings schemas for file dialogues */ ''
#    rm "$out/share/icons/hicolor/icon-theme.cache"
#  '';

  meta = with stdenv.lib; {
    description = "A fast, easy and free BitTorrent client";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
      Feature spotlight:
        * Uses fewer resources than other clients
        * Native Mac, GTK+ and Qt GUI clients
        * Daemon ideal for servers, embedded systems, and headless use
        * All these can be remote controlled by Web and Terminal clients
        * Bluetack (PeerGuardian) blocklists with automatic updates
        * Full encryption, DHT, and PEX support
    '';
    homepage = http://www.transmissionbt.com/;
    license = licenses.gpl2; # parts are under MIT
    maintainers = with maintainers; [ astsmtl vcunat wizeman ];
    platforms = platforms.linux;
  };
}

