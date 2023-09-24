{ lib, stdenv, fetchFromGitHub, mpiCheckPhaseHook, python3, gfortran, blas, lapack
, fftw, libint, libvori, libxc, mpi, gsl, scalapack, openssh, makeWrapper
, libxsmm, spglib, which, pkg-config, plumed, zlib
, enableElpa ? false
, elpa
} :

let
  cp2kVersion = "psmp";
  arch = "Linux-x86-64-gfortran";

in stdenv.mkDerivation rec {
  pname = "cp2k";
  version = "2023.2";

  src = fetchFromGitHub {
    owner = "cp2k";
    repo = "cp2k";
    rev = "v${version}";
    hash = "sha256-1TJorIjajWFO7i9vqSBDTAIukBdyvxbr5dargt4QB8M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ python3 which openssh makeWrapper pkg-config ];
  buildInputs = [
    gfortran
    fftw
    gsl
    libint
    libvori
    libxc
    libxsmm
    spglib
    scalapack
    blas
    lapack
    plumed
    zlib
  ] ++ lib.optional enableElpa elpa;

  propagatedBuildInputs = [ mpi ];
  propagatedUserEnvPkgs = [ mpi ];

  makeFlags = [
    "ARCH=${arch}"
    "VERSION=${cp2kVersion}"
  ];

  doCheck = true;

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs tools exts/dbcsr/tools/build_utils exts/dbcsr/.cp2k
    substituteInPlace exts/build_dbcsr/Makefile \
      --replace '/usr/bin/env python3' '${python3}/bin/python' \
      --replace 'SHELL = /bin/sh' 'SHELL = bash'
  '';

  configurePhase = ''
    cat > arch/${arch}.${cp2kVersion} << EOF
    CC         = mpicc
    CPP        =
    FC         = mpif90
    LD         = mpif90
    AR         = ar -r
    DFLAGS     = -D__FFTW3 -D__LIBXC -D__LIBINT -D__parallel -D__SCALAPACK \
                 -D__MPI_VERSION=3 -D__F2008 -D__LIBXSMM -D__SPGLIB \
                 -D__MAX_CONTR=4 -D__LIBVORI ${lib.optionalString enableElpa "-D__ELPA"} \
                 -D__PLUMED2
    CFLAGS    = -fopenmp
    FCFLAGS    = \$(DFLAGS) -O2 -ffree-form -ffree-line-length-none \
                 -ftree-vectorize -funroll-loops -msse2 \
                 -std=f2008 \
                 -fopenmp -ftree-vectorize -funroll-loops \
                 -I${libxc}/include -I${libxsmm}/include \
                 -I${libint}/include ${lib.optionalString enableElpa "$(pkg-config --variable=fcflags elpa)"}
    LIBS       = -lfftw3 -lfftw3_threads \
                 -lscalapack -lblas -llapack \
                 -lxcf03 -lxc -lxsmmf -lxsmm -lsymspg \
                 -lint2 -lstdc++ -lvori \
                 -lgomp -lpthread -lm \
                 -fopenmp ${lib.optionalString enableElpa "$(pkg-config --libs elpa)"} \
                 -lz -ldl -lstdc++ ${lib.optionalString (mpi.pname == "openmpi") "$(mpicxx --showme:link)"} \
                 -lplumed
    LDFLAGS    = \$(FCFLAGS) \$(LIBS)
    include ${plumed}/lib/plumed/src/lib/Plumed.inc
    EOF
  '';

  nativeCheckInputs = [
    mpiCheckPhaseHook
    openssh
  ];

  checkPhase = ''
    runHook preCheck

    export CP2K_DATA_DIR=data
    mpirun -np 2 exe/${arch}/libcp2k_unittest.${cp2kVersion}

    runHook postCheck
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/cp2k

    cp exe/${arch}/* $out/bin

    for i in cp2k cp2k_shell graph; do
      wrapProgram $out/bin/$i.${cp2kVersion} \
        --set-default CP2K_DATA_DIR $out/share/cp2k
    done

    wrapProgram $out/bin/cp2k.popt \
      --set-default CP2K_DATA_DIR $out/share/cp2k \
      --set OMP_NUM_THREADS 1

    cp -r data/* $out/share/cp2k
  '';

  passthru = { inherit mpi; };

  meta = with lib; {
    description = "Quantum chemistry and solid state physics program";
    homepage = "https://www.cp2k.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sheepforce ];
    platforms = [ "x86_64-linux" ];
  };
}
