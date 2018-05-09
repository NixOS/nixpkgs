{ libsmbios, stdenv, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "netperf-20180504";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "netperf";
    rev = "c0a0d9f31f9940abf375a41b43a343cdbf87caab";
    sha256 = "0wfj9kkhar6jb5639f5wxpwsraxw4v9yzg71rsdidvj5fyncjjq2";
  };

  buildInputs = [ libsmbios ];
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
