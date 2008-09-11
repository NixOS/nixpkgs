{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.0.3";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-1.0.3.tar.bz2;
    sha256 = "1wmkbq0rgy7rz8mqggyay98z4qd3s9bnv5lmvx1r55sndcq6z2bp";
  };
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
