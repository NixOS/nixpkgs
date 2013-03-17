{ stdenv, fetchurl, pkgconfig, openssl, curl, intltool, libevent,
  file, inotifyTools, gtk ? null }:

stdenv.mkDerivation rec {
  name = "transmission-2.60"; # transmission >= 2.61 requires gtk3

  src = fetchurl {
    url = "http://download.transmissionbt.com/files/${name}.tar.xz";
    sha256 = "1ramdliyy8j7qqpkxg643lda11ynxwfhq6qcs31fr3h9x72l0rg4";
  };

  buildInputs = [ pkgconfig openssl curl intltool libevent
                  file inotifyTools gtk ];

  preConfigure = ''
    sed -i -e 's|/usr/bin/file|${file}/bin/file|g' configure
  '';

  postInstall = ''
    rm -f $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = {
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
    license = [ "GPLv2" ];
    maintainers = [ stdenv.lib.maintainers.astsmtl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
