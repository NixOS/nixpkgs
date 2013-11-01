{ stdenv, fetchurl, pkgconfig, intltool, file, makeWrapper
, openssl, curl, libevent, inotifyTools
, enableGTK3 ? false, gtk3
}:

let
  version = "2.82";
in

with { inherit (stdenv.lib) optional optionals optionalString; };

stdenv.mkDerivation rec {
  name = "transmission-" + optionalString enableGTK3 "gtk-" + version;

  src = fetchurl {
    url = "http://download.transmissionbt.com/files/transmission-${version}.tar.xz";
    sha256 = "08imy28hpjxwdzgvhm66hkfyzp8qnnqr4jhv3rgshryzhw86b5ir";
  };

  buildInputs = [ pkgconfig intltool file openssl curl libevent inotifyTools ]
    ++ optionals enableGTK3 [ gtk3 makeWrapper ];

  preConfigure = ''
    sed -i -e 's|/usr/bin/file|${file}/bin/file|g' configure
  '';

  configureFlags = [ "--with-systemd-daemon" ]
    ++ optional enableGTK3 "--with-gtk";

  postInstall = optionalString enableGTK3 /* gsettings schemas for file dialogues */ ''
    rm "$out/share/icons/hicolor/icon-theme.cache"
    wrapProgram "$out/bin/transmission-gtk" \
      --prefix XDG_DATA_DIRS : "${gtk3}/share"
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
    maintainers = with maintainers; [ astsmtl vcunat ];
    platforms = platforms.linux;
  };
}

