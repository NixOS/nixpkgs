{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "netperf-2.5.0";

  src = fetchurl {
    url = "ftp://ftp.netperf.org/netperf/${name}.tar.bz2";
    sha256 = "1l06bb99b4wfnmq247b8rvp4kn3w6bh1m46ri4d74z22li7br545";
  };
}

