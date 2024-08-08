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
}:
stdenv.mkDerivation (finalAttrs: {
  name = "mumps";
  version = "5.7.3";

  src = fetchzip {
    url = "https://mumps-solver.org/MUMPS_${finalAttrs.version}.tar.gz";
    hash = "sha256-ZnIfAuvOBJDYqCtKGlWs0r39nG6X2lAVRuUmeIJenZw=";
  };

  patches = [
    # Compatibility with coin-or-mumps version
    (fetchpatch {
      url = "https://raw.githubusercontent.com/coin-or-tools/ThirdParty-Mumps/bd0bdf9baa3f3677bd34fb36ce63b2b32cc6cc7d/mumps_mpi.patch";
      hash = "sha256-70qZUKBVBpJOSRxYxng5Y6ct1fdCUQUGur3chDhGabQ=";
    })
  ];

  postPatch = ''
    # Compatibility with coin-or-mumps version
    # https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps#L66
    cp libseq/mpi.h libseq/mumps_mpi.h
  '';

  configurePhase = ''
    cp Make.inc/Makefile.debian.SEQ ./Makefile.inc
  '';

  makeFlags =
    lib.optionals stdenv.isDarwin [
      "SONAME="
      "LIBEXT_SHARED=.dylib"
    ]
    ++ [
      "LSCOTCHDIR=${scotch}/lib"
      "ISCOTCH=-I${scotch}/include"
      "LMETISDIR=${metis}/lib"
      "IMETIS=-I${metis}/include"
      "allshared"
    ];

  installPhase = ''
    mkdir $out
    cp -r include lib $out

    # Add some compatibility with coin-or-mumps
    ln -s $out/include $out/include/mumps
    cp libseq/mumps_mpi.h $out/include
  '';

  nativeBuildInputs = [ gfortran ];

  buildInputs = [
    blas
    lapack
    metis
    scotch
  ];

  meta = {
    description = "MUltifrontal Massively Parallel sparse direct Solver";
    homepage = "http://mumps-solver.org/";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [ nim65s ];
    broken = stdenv.isDarwin;
  };
})
