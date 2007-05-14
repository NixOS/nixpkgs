{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap}:

stdenv.mkDerivation {
  name = "wireshark-0.99.5";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-0.99.5.tar.gz;
    sha256 = "0a6fkfdypfp73h1zxva2qxsm2mpkp1jv7p3d42xv5ghfwjqxyi0i";
  };
  buildInputs = [perl pkgconfig gtk libpcap];
}
