{
  libsmbios,
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "netperf";
  version = "20210121";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = "netperf";
    rev = "3bc455b23f901dae377ca0a558e1e32aa56b31c4";
    sha256 = "s4G1ZN+6LERdEMDkc+12ZQgTi6K+ppUYUCGn4faCS9c=";
  };

  patches = [
    # Pul fix pending upstream inclusion for -fno-common toolchains:
    #   https://github.com/HewlettPackard/netperf/pull/46
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/HewlettPackard/netperf/commit/c6a2e17fe35f0e68823451fedfdf5b1dbecddbe3.patch";
      sha256 = "P/lRa6EakSalKWDTgZ7bWeGleaTLLa5UhzulxKd1xE4=";
    })
  ];

  buildInputs = lib.optional (with stdenv.hostPlatform; isx86 && isLinux) libsmbios;
  nativeBuildInputs = [ autoreconfHook ];
  autoreconfPhase = ''
    autoreconf -i -I src/missing/m4
  '';
  configureFlags = [
    "--enable-demo"
    "CFLAGS=-D_GNU_SOURCE"
  ];
  enableParallelBuilding = true;

  meta = {
    description = "Benchmark to measure the performance of many different types of networking";
    homepage = "https://github.com/HewlettPackard/netperf/";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mmlb ];
  };
}
