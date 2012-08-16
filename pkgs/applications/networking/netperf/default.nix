{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "netperf-2.6.0";

  src = fetchurl {
    url = "ftp://ftp.netperf.org/netperf/${name}.tar.bz2";
    sha256 = "cd8dac710d4273d29f70e8dbd09353a6362ac58a11926e0822233c0cb230323a";
  };

  meta = {
    description = "benchmark to measure the performance of many different types of networking";
    homepage = "http://www.netperf.org/netperf/";
    license = "Hewlett-Packard BSD-like license";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [];
  };
}
