{
  blas,
  fetchzip,
  fetchpatch,
  gfortran,
  lapack,
  lib,
  metis,
  parmetis,
  withParmetis ? false, # default to false due to unfree license
  scotch,
  withPtScotch ? mpiSupport,
  stdenv,
  fixDarwinDylibNames,
  mpi,
  mpiSupport ? false,
  mpiCheckPhaseHook,
  scalapack,
}:
assert withParmetis -> mpiSupport;
assert withPtScotch -> mpiSupport;
let
  profile = if mpiSupport then "debian.PAR" else "debian.SEQ";
  metisFlags =
    if withParmetis then
      ''
        IMETIS="-I${parmetis}/include -I${metis}/include" \
        LMETIS="-L${parmetis}/lib -lparmetis -L${metis}/lib -lmetis"
      ''
    else
      ''
        IMETIS=-I${metis}/include \
        LMETIS="-L${metis}/lib -lmetis"
      '';
  scotchFlags =
    if withPtScotch then
      ''
        ISCOTCH=-I${scotch.dev}/include \
        LSCOTCH="-L${scotch}/lib -lptscotch -lptesmumps -lptscotcherr"
      ''
    else
      ''
        ISCOTCH=-I${scotch.dev}/include \
        LSCOTCH="-L${scotch}/lib -lesmumps -lscotch -lscotcherr"
      '';
  macroFlags =
    "-Dmetis -Dpord -Dscotch"
    + lib.optionalString withParmetis " -Dparmetis"
    + lib.optionalString withPtScotch " -Dptscotch";
  # Optimized options
  # Disable -fopenmp in lines below to benefit from OpenMP
  optFlags = ''
    OPTF="-O3 -fallow-argument-mismatch" \
    OPTL="-O3" \
    OPTC="-O3"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  name = "mumps";
  version = "5.7.3";

  src = fetchzip {
    url = "https://mumps-solver.org/MUMPS_${finalAttrs.version}.tar.gz";
    hash = "sha256-ZnIfAuvOBJDYqCtKGlWs0r39nG6X2lAVRuUmeIJenZw=";
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

  preBuild = ''
    makeFlagsArray+=(${metisFlags} ${scotchFlags} ORDERINGSF="${macroFlags}" ${optFlags})
  '';

  makeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "SONAME="
      "LIBEXT_SHARED=.dylib"
    ]
    ++ [
      "SCALAP=-lscalapack"
      "allshared"
    ];

  installPhase =
    ''
      mkdir $out
      cp -r include lib $out
    ''
    + lib.optionalString (!mpiSupport) ''
      # Install mumps_seq headers
      install -Dm 444 -t $out/include/mumps_seq libseq/*.h

      # Add some compatibility with coin-or-mumps
      ln -s $out/include/mumps_seq/mpi.h $out/include/mumps_mpi.h
    '';

  nativeBuildInputs =
    [
      gfortran
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
    ++ lib.optional mpiSupport mpi;

  # Parmetis should be placed before scotch to avoid conflict of header file "parmetis.h"
  buildInputs =
    lib.optional withParmetis parmetis
    ++ lib.optional mpiSupport scalapack
    ++ [
      blas
      lapack
      metis
      scotch
    ];

  doInstallCheck = true;
  nativeInstallCheckInputs = lib.optional mpiSupport mpiCheckPhaseHook;
  installCheckPhase = ''
    runHook preInstallCheck
    ${lib.optionalString stdenv.hostPlatform.isDarwin "export DYLD_LIBRARY_PATH=$out/lib\n"}
    ${lib.optionalString mpiSupport "export MPIRUN='mpirun -n 2'\n"}
    cd examples
    make all
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
    homepage = "http://mumps-solver.org/";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [
      nim65s
      qbisi
    ];
    platforms = lib.platforms.unix;
    # Dependency of scalapack for mpiSupport is broken on darwin platform
    broken = mpiSupport && stdenv.hostPlatform.isDarwin;
  };
})
