{stdenv, fetchurl, perl, pkgconfig, gtk, libpcap, flex, bison}:

stdenv.mkDerivation {
  name = "wireshark-1.0.2";
  src = fetchurl {
    url = http://www.wireshark.org/download/src/wireshark-1.0.2.tar.gz;
    sha256 = "0lv5agsb6ivqz2271yyiq5lsq7xvr35cxzikciq82rn7v8bj0qc9";
  };
  buildInputs = [perl pkgconfig gtk libpcap flex bison];
}
