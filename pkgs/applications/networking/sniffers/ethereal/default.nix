{stdenv, fetchurl, perl, pkgconfig, glib, libpcap}:

stdenv.mkDerivation {
  name = "ethereal-0.99";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/ethereal-0.99.0.tar.bz2;
    md5 = "f9905b9d347acdc05af664a7553f7f76";
  };
  buildInputs = [perl pkgconfig glib libpcap];
}
