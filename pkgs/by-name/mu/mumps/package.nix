{
  blas,
  fetchzip,
  fetchpatch,
  gfortran,
  lapack,
  lib,
  metis,
  scotch,
  stdenv,
  fixDarwinDylibNames,
}:
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
    cp Make.inc/Makefile.debian.SEQ ./Makefile.inc
  '';

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals stdenv.hostPlatform.isDarwin [
      "SONAME="
      "LIBEXT_SHARED=.dylib"
    ]
    ++ [
      "LSCOTCHDIR=${scotch}/lib"
      "ISCOTCH=-I${scotch.dev}/include"
      "LMETISDIR=${metis}/lib"
      "IMETIS=-I${metis}/include"
      "allshared"
    ];

  installPhase = ''
    mkdir $out
    cp -r include lib $out

    # Install mumps_seq headers
    install -Dm 444 -t $out/include/mumps_seq libseq/*.h

    # Add some compatibility with coin-or-mumps
    ln -s $out/include/mumps_seq/mpi.h $out/include/mumps_mpi.h
  '';

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ]
    ++ [
      gfortran
    ];

  buildInputs = [
    blas
    lapack
    metis
    scotch
  ];

  doInstallCheck = true;
  installCheckPhase =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      export DYLD_LIBRARY_PATH=$out/lib
    ''
    + ''
      cd examples
      make all
      ./ssimpletest <input_simpletest_real
      ./dsimpletest <input_simpletest_real
      ./csimpletest <input_simpletest_cmplx
      ./zsimpletest <input_simpletest_cmplx
      ./c_example
      ./multiple_arithmetics_example
      ./ssimpletest_save_restore <input_simpletest_real
      ./dsimpletest_save_restore <input_simpletest_real
      ./csimpletest_save_restore <input_simpletest_cmplx
      ./zsimpletest_save_restore <input_simpletest_cmplx
      ./c_example_save_restore
    '';

  meta = {
    description = "MUltifrontal Massively Parallel sparse direct Solver";
    homepage = "http://mumps-solver.org/";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
