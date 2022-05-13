{ libsmbios, lib, stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "netperf";
  version = "20210121";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "netperf";
    rev = "3bc455b23f901dae377ca0a558e1e32aa56b31c4";
    sha256 = "s4G1ZN+6LERdEMDkc+12ZQgTi6K+ppUYUCGn4faCS9c=";
  };

  buildInputs = lib.optional (with stdenv.hostPlatform; isx86 && isLinux) libsmbios;
  nativeBuildInputs = [ autoreconfHook ];
  autoreconfPhase = ''
    autoreconf -i -I src/missing/m4
  '';
  configureFlags = [ "--enable-demo" ];
  enableParallelBuilding = true;

  meta = {
    description = "Benchmark to measure the performance of many different types of networking";
    homepage = "http://www.netperf.org/netperf/";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mmlb ];
  };
}
