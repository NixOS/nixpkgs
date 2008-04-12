{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-0.99.7";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/all-versions/wireshark-1.0.0.tar.bz2;
    sha256 = "1l4zrmxf3i2i8a5f953pbbpy1c44d1q3r79hbzq7q9x78vhi6ixm";
  };
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
