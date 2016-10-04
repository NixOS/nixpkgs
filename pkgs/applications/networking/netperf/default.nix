{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "netperf-2.7.0";

  src = fetchurl {
    url = "ftp://ftp.netperf.org/netperf/${name}.tar.bz2";
    sha256 = "0nip8178pdry0pqx2gkz0sl2gcvc7qww621q43kqnp43amvg2al4";
  };

  meta = {
    description = "Benchmark to measure the performance of many different types of networking";
    homepage = "http://www.netperf.org/netperf/";
    license = "Hewlett-Packard BSD-like license";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [];
  };
}
