{
  lib,
  stdenv,
  fetchzip,
  mpi,
  gfortran,
  fixDarwinDylibNames,
  blas,
  lapack,
  scalapack,
  scotch,
  metis,
  parmetis,
  mpiCheckPhaseHook,
  static ? stdenv.hostPlatform.isStatic,
  mpiSupport ? false,
  withParmetis ? false, # default to false due to unfree license
  withPtScotch ? mpiSupport,
}:
assert withParmetis -> mpiSupport;
assert withPtScotch -> mpiSupport;
let
  scotch' = scotch.override { inherit withPtScotch; };
  profile = if mpiSupport then "debian.PAR" else "debian.SEQ";
  LMETIS = toString ([ "-lmetis" ] ++ lib.optional withParmetis "-lparmetis");
  LSCOTCH = toString (
    if withPtScotch then
      [
        "-lptscotch"
        "-lptesmumps"
        "-lptscotcherr"
      ]
    else
      [
        "-lesmumps"
        "-lscotch"
        "-lscotcherr"
      ]
  );
  ORDERINGSF = toString (
    [
      "-Dmetis"
      "-Dpord"
      "-Dscotch"
    ]
    ++ lib.optional withParmetis "-Dparmetis"
    ++ lib.optional withPtScotch "-Dptscotch"
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mumps";
  version = "5.8.1";
  # makeFlags contain space and one should use makeFlagsArray+
  # Setting this magic var is an optional solution
  __structuredAttrs = true;

  strictDeps = true;

  src = fetchzip {
    url = "https://mumps-solver.org/MUMPS_${finalAttrs.version}.tar.gz";
    hash = "sha256-60hNYhbHONv9E9VY8G0goE83q7AwJh1u/Z+QRK8anHQ=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/Makefile --replace-fail \
      "-Wl,\''$(SONAME),libmumps_common" \
      "-Wl,-install_name,$out/lib/libmumps_common"
  '';

  configurePhase = ''
    cp Make.inc/Makefile.${profile} ./Makefile.inc
  '';

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "SONAME="
      "LIBEXT_SHARED=.dylib"
    ]
    ++ [
      "ISCOTCH=-I${lib.getDev scotch'}/include"
      "LMETIS=${LMETIS}"
      "LSCOTCH=${LSCOTCH}"
      "ORDERINGSF=${ORDERINGSF}"
      "OPTF=-O3 -fallow-argument-mismatch"
      "OPTC=-O3"
      "OPTL=-O3"
      "SCALAP=-lscalapack"
      "${if static then "all" else "allshared"}"
    ];

  installPhase = ''
    mkdir $out
    cp -r include lib $out
  ''
  + lib.optionalString (!mpiSupport) ''
    # Install mumps_seq headers
    install -Dm 444 -t $out/include/mumps_seq libseq/*.h

    # Add some compatibility with coin-or-mumps
    ln -s $out/include/mumps_seq/mpi.h $out/include/mumps_mpi.h
  '';

  nativeBuildInputs = [
    gfortran
  ]
  ++ lib.optional mpiSupport mpi
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    blas
    lapack
    metis
    scotch'
  ]
  ++ lib.optional mpiSupport scalapack
  ++ lib.optional withParmetis parmetis;

  doInstallCheck = true;

  nativeInstallCheckInputs = lib.optional mpiSupport mpiCheckPhaseHook;

  installCheckPhase = ''
    runHook preInstallCheck

    ${lib.optionalString stdenv.hostPlatform.isDarwin "export DYLD_LIBRARY_PATH=$out/lib\n"}
    ${lib.optionalString mpiSupport "export MPIRUN='mpirun -n 2'\n"}
    cd examples
    $MPIRUN ./ssimpletest <input_simpletest_real
    $MPIRUN ./dsimpletest <input_simpletest_real
    $MPIRUN ./csimpletest <input_simpletest_cmplx
    $MPIRUN ./zsimpletest <input_simpletest_cmplx
    $MPIRUN ./c_example
    $MPIRUN ./multiple_arithmetics_example
    $MPIRUN ./ssimpletest_save_restore <input_simpletest_real
    $MPIRUN ./dsimpletest_save_restore <input_simpletest_real
    $MPIRUN ./csimpletest_save_restore <input_simpletest_cmplx
    $MPIRUN ./zsimpletest_save_restore <input_simpletest_cmplx
    $MPIRUN ./c_example_save_restore

    runHook postInstallCheck
  '';

  passthru = {
    inherit withParmetis withPtScotch mpiSupport;
  };

  meta = {
    description = "MUltifrontal Massively Parallel sparse direct Solver";
    homepage = "https://mumps-solver.org/";
    changelog = "https://mumps-solver.org/index.php?page=dwnld#cl";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [
      nim65s
      qbisi
    ];
    platforms = lib.platforms.unix;
  };
})
