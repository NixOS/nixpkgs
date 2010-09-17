{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.4.0rc2";
  src = fetchurl {
    url = "http://www.wireshark.org/download/src/wireshark-1.4.0rc2.tar.bz2";
    sha256 = "16fd00e1e120c7f57a8c5c8532f26d77a14ca254c2cb2c4816ec9a0499744f79";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
