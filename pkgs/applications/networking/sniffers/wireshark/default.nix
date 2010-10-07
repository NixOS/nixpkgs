{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation rec {
  version = "1.4.0";
  name = "wireshark-${version}";
  src = fetchurl {
    url = "http://www.wireshark.org/download/src/${name}.tar.bz2";
    sha256 = "1c0df77d11c643b1142b6ed3fd21e0c79b3f05f1749fe10e9ba5fd3beee8b743";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
