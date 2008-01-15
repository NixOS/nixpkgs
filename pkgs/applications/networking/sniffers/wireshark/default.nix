{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap}:

stdenv.mkDerivation {
  name = "wireshark-0.99.7";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-0.99.7.tar.bz2;
    sha256 = "10pb2mn6p40gsq2nbnqdzihrpa078jdgxqh8l4zs33bxa1h37frc";
  };
  buildInputs = [perl pkgconfig gtk libpcap];
}
