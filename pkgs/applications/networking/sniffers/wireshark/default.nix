{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.3.0";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-1.3.0.tar.gz;
    sha256 = "06vn6yklbg2ajh0gs0j58d4fwkkjxz8xn5f8xlpfkffs2m80aw2r";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
