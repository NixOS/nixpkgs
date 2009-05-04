{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.1.3";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-1.1.3.tar.gz;
    sha256 = "0j2ng84di0lyjax80mw74lmcipxkmlbld4w2yms93932wbxij3s1";
  };
  configureFlags = "--with-pcap=${libpcap}";
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
