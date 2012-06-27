{ stdenv, fetchurl, pkgconfig, openssl, curl, intltool, libevent, gtkClient ? true, gtk }:

stdenv.mkDerivation rec {
  name = "transmission-2.52";

  src = fetchurl {
    url = "http://download.transmissionbt.com/files/${name}.tar.xz";
    sha256 = "05sfq5h3731xc9a1k5r1q4gbs9yk0dr229asfxjjgg0lw1xzppdw";
  };

  buildInputs = [ pkgconfig openssl curl intltool libevent ] ++
                stdenv.lib.optional gtkClient gtk;

  configureFlags = if gtkClient then "--enable-gtk" else "--disable-gtk";

  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
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
