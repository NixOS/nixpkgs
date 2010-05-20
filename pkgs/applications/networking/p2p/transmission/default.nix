{ stdenv, fetchurl, pkgconfig, openssl, curl, intltool, gtkClient ? true, gtk }:

stdenv.mkDerivation rec {
  name = "transmission-1.93";
  
  src = fetchurl {
    url = "http://mirrors.m0k.org/transmission/files/${name}.tar.bz2";
    sha256 = "0w0nsyw10h4lm57qc09ja4iqqwvzcjldnqxi4zp0ha5dkbxv3dz9";
  };
  
  buildInputs = [ pkgconfig openssl curl intltool ] ++ stdenv.lib.optional gtkClient gtk;
  
  configureFlags = if gtkClient then "--enable-gtk" else "--disable-gtk";
  
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
