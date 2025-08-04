{
  lib,
  stdenv,
  fetchFromGitHub,
  cudd,
  gmp-static,
  gperf,
  autoreconfHook,
  libpoly,
}:

stdenv.mkDerivation rec {
  pname = "yices";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = "yices2";
    rev = "Yices-${version}";
    hash = "sha256-/sKyHkFW5I5kojNIRPEKojzTvfRZiyVIN5VlBIbAV7k=";
  };

  postPatch = "patchShebangs tests/regress/check.sh";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    cudd
    gmp-static
    gperf
    libpoly
  ];
  configureFlags = [
    "--with-static-gmp=${gmp-static.out}/lib/libgmp.a"
    "--with-static-gmp-include-dir=${gmp-static.dev}/include"
    "--enable-mcsat"
  ];

  enableParallelBuilding = true;
  doCheck = true;

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage = "https://yices.csl.sri.com";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
