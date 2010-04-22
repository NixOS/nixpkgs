{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.3.4";
  src = fetchurl {
    url = http://media-2.cacetech.com/wireshark/src/wireshark-1.3.4.tar.bz2;
    sha256 = "00pyr3izg5dg8kr4sayp0fq8q360syfhs2nvj6b4ff1mdal7ra3x";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
