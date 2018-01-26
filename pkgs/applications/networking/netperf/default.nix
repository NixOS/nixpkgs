{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "netperf-2.7.0";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "netperf";
    rev = name;
    sha256 = "034indn3hicwbvyzgw9f32bv2i7c5iv8b4a11imyn03pw97jzh10";
  };

  meta = {
    description = "Benchmark to measure the performance of many different types of networking";
    homepage = http://www.netperf.org/netperf/;
    license = "Hewlett-Packard BSD-like license";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [];
  };
}
