{ libsmbios, stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "netperf-${version}";
  version = "20180613";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "netperf";
    rev = "bcb868bde7f0203bbab69609f65d4088ba7398db";
    sha256 = "1wbbgdvhadd3qs3afv6i777argdpcyxkwz4yv6aqp223n8ki6dm8";
  };

  buildInputs = stdenv.lib.optional (stdenv.hostPlatform.isx86) libsmbios;
  nativeBuildInputs = [ autoreconfHook ];
  autoreconfPhase = ''
    autoreconf -i -I src/missing/m4
  '';
  configureFlags = [ "--enable-demo" ];
  enableParallelBuilding = true;

  meta = {
    description = "Benchmark to measure the performance of many different types of networking";
    homepage = http://www.netperf.org/netperf/;
    license = "Hewlett-Packard BSD-like license";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mmlb ];
  };
}
