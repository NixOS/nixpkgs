{ stdenv, fetchurl, pkgconfig, intltool, file, makeWrapper
, openssl, curl, libevent, inotifyTools, systemd
, enableGTK3 ? false, gtk3
}:

let
  version = "2.84";
in

with { inherit (stdenv.lib) optional optionals optionalString; };

stdenv.mkDerivation rec {
  name = "transmission-" + optionalString enableGTK3 "gtk-" + version;

  src = fetchurl {
    url = "http://download.transmissionbt.com/files/transmission-${version}.tar.xz";
    sha256 = "1sxr1magqb5s26yvr5yhs1f7bmir8gl09niafg64lhgfnhv1kz59";
  };

  buildInputs = [ pkgconfig intltool file openssl curl libevent inotifyTools ]
    ++ optionals enableGTK3 [ gtk3 makeWrapper ]
    ++ optional stdenv.isLinux systemd;

  preConfigure = ''
    sed -i -e 's|/usr/bin/file|${file}/bin/file|g' configure
  '';

  configureFlags = [ "--with-systemd-daemon" ]
    ++ optional enableGTK3 "--with-gtk";

  preFixup = optionalString enableGTK3 /* gsettings schemas for file dialogues */ ''
    rm "$out/share/icons/hicolor/icon-theme.cache"
    wrapProgram "$out/bin/transmission-gtk" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

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

