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

  postPatch =
    ''
      # Compatibility with coin-or-mumps version
      # https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps#L66
      cp libseq/mpi.h libseq/mumps_mpi.h
    ''
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/Makefile --replace-fail \
        "-Wl,\''$(SONAME),libmumps_common" \
        "-Wl,-install_name,$out/lib/libmumps_common"
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

  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool \
      -change    libmpiseq.dylib \
        $out/lib/libmpiseq.dylib \
      -change    libpord.dylib \
        $out/lib/libpord.dylib \
        $out/lib/libmumps_common.dylib
    install_name_tool \
      -change    libmpiseq.dylib \
        $out/lib/libmpiseq.dylib \
      -change    libpord.dylib \
        $out/lib/libpord.dylib \
      -id \
        $out/lib/libcmumps.dylib \
        $out/lib/libcmumps.dylib
    install_name_tool \
      -change    libmpiseq.dylib \
        $out/lib/libmpiseq.dylib \
      -change    libpord.dylib \
        $out/lib/libpord.dylib \
      -id \
        $out/lib/libdmumps.dylib \
        $out/lib/libdmumps.dylib
    install_name_tool \
      -change    libmpiseq.dylib \
        $out/lib/libmpiseq.dylib \
      -change    libpord.dylib \
        $out/lib/libpord.dylib \
      -id \
        $out/lib/libsmumps.dylib \
        $out/lib/libsmumps.dylib
    install_name_tool \
      -change    libmpiseq.dylib \
        $out/lib/libmpiseq.dylib \
      -change    libpord.dylib \
        $out/lib/libpord.dylib \
      -id \
        $out/lib/libzmumps.dylib \
        $out/lib/libzmumps.dylib
    install_name_tool \
      -id \
        $out/lib/libmpiseq.dylib \
        $out/lib/libmpiseq.dylib
    install_name_tool \
      -id \
        $out/lib/libpord.dylib \
        $out/lib/libpord.dylib
  '';

  meta = {
    description = "MUltifrontal Massively Parallel sparse direct Solver";
    homepage = "http://mumps-solver.org/";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
