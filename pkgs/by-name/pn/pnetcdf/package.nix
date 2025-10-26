{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  autoreconfHook,
  perl,
  mpi,
  mpiCheckPhaseHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pnetcdf";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "Parallel-NetCDF";
    repo = "PnetCDF";
    tag = "checkpoint.${finalAttrs.version}";
    hash = "sha256-nz40Ji9qh6UatlLOuChsWYvHwfVNacJI87usGBcYyFk=";
  };

  nativeBuildInputs = [
    perl
    autoreconfHook
    gfortran
  ];

  buildInputs = [ mpi ];

  postPatch = ''
    patchShebangs src/binding/f77/buildiface test examples benchmarks
  '';

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  nativeCheckInputs = [ mpiCheckPhaseHook ];

  checkTarget = lib.concatStringsSep " " [
    # build all test programs (build only, no run)
    "tests"
    # run sequential test programs
    "check"
    # run parallel test programs on 3,4,6,8 MPI processes
    "ptests"
  ];

  # cannot do parallel check otherwise failed
  enableParallelChecking = false;

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "checkpoint.";
  };

  meta = {
    homepage = "https://parallel-netcdf.github.io/";
    license = with lib.licenses; [
      # Files: *
      # Copyright: (c) 2003 Northwestern University and Argonne National Laboratory
      bsd3

      # Files: src/drivers/common/utf8proc.c
      # Copyright: (c) 2006-2007 Jan Behrens, FlexiGuided GmbH, Berlin
      mit

      # Files: src/drivers/common/utf8proc_data.c
      # Copyright: 1991-2007 Unicode, Inc.
      unicode-30
    ];
    description = "Parallel I/O Library for NetCDF File Access";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
