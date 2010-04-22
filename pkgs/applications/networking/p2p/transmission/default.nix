{ stdenv, fetchurl, pkgconfig, openssl, curl, intltool, gtkClient ? true, gtk }:
stdenv.mkDerivation rec {
  name = "transmission-1.92";
  src = fetchurl {
    url = "http://mirrors.m0k.org/transmission/files/${name}.tar.bz2";
    sha256 = "1vdvl3aza5cip4skhd2y4ip2vjci7q3y3qi3008ykk28ga93gw6s";
  };
  buildInputs = [ pkgconfig openssl curl intltool ] ++ stdenv.lib.optional gtkClient gtk;
  configureFlags = if gtkClient then "--enable-gtk" else "--disable-gtk";
  meta = {
    description = "A fast, easy and free BitTorrent client.";
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
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
