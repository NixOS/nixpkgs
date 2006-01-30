{stdenv, fetchurl, perl, pkgconfig, glib, libpcap}:

stdenv.mkDerivation {
  name = "ethereal-0.10.14";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ethereal-0.10.14.tar.bz2;
    md5 = "297f678c037f88429250830e924b8fa0";
  };
  buildInputs = [perl pkgconfig glib libpcap];
}
