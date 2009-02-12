{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.1.2";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-1.1.2.tar.gz;
    sha256 = "0fsf84czzxg0gpyf525lx2c9i8la26fkhqv4visz5bz2r0911yd4";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
