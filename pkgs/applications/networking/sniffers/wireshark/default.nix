{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation rec {
  version = "1.4.2";
  name = "wireshark-${version}";
  src = fetchurl {
    url = "http://www.wireshark.org/download/src/${name}.tar.bz2";
    sha256 = "1cj9n3yhahj6pabx1h1gas6b6dhwsljjz2w3ngky3a4g6bnf3ij4";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
