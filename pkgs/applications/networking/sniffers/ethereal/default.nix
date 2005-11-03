{stdenv, fetchurl, perl, pkgconfig, glib, libpcap}:

stdenv.mkDerivation {
  name = "ethereal-0.10.13";
  src = fetchurl {
    url = ftp://ftp.sunet.se/pub/network/monitoring/ethereal/ethereal-0.10.13.tar.bz2;
    md5 = "08d277951ff6f6a93c752abebd85d5bc";
  };
  buildInputs = [perl pkgconfig glib libpcap];
}
