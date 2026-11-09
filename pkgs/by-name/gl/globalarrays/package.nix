{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  blas,
  gfortran,
  openssh,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "globalarrays";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    tag = "v${finalAttrs.version}";
    hash = "sha256-leCvbWteOp7z7ORwtljA+KslHUptY2vdupZTmAjsArg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gfortran
    mpi
    openssh
  ];

  buildInputs = [
    mpi
    blas
  ];

  passthru = { inherit (blas) isILP64; };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  strictDeps = true;
  __structuredAttrs = true;

  configureFlags = [
    "--with-mpi"
    "--with-mpi3"
    "--enable-eispack"
    "--enable-underscoring"
  ]
  ++ lib.optionals blas.isILP64 [
    "--enable-i8"
    "--with-blas8=-lblas"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Global Arrays Programming Models";
    homepage = "http://hpc.pnl.gov/globalarrays/";
    maintainers = [ lib.maintainers.markuskowa ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
