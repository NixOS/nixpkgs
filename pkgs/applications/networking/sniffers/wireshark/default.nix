{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap}:

stdenv.mkDerivation {
  name = "wireshark-0.99.6";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-0.99.6.tar.gz;
    sha256 = "1f2i84dk4nw05nh78b2j4n9pbwdngcqx0grrja5831r6paj35x1y";
  };
  buildInputs = [perl pkgconfig gtk libpcap];
}
