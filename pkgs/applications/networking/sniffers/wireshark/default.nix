{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.3.2";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-1.3.2.tar.gz;
    sha256 = "0sq0mk0iqsgcgd2gqspyfmjiql00d3ghq43qxywd8qb2jxfv1q5r";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
