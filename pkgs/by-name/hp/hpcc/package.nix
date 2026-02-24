{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  mpi,
  blas,
  lapack,
}:

let
  mpiDev = lib.getDev mpi;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "hpcc";
  version = "1.5.0";

  src = fetchurl {
    url = "https://hpcchallenge.org/projectsfiles/hpcc/download/hpcc-${finalAttrs.version}.tar.gz";
    hash = "sha256-Cm/vernzNH5Un+1l67mCNP7qnuGK6gyPWbrvvjz3/7g=";
  };

  # HPCC uses old version of MPI: Fix compatibility with MPI-3 (OpenMPI 5.x)
  # MPI_Address -> MPI_Get_address, MPI_Type_struct -> MPI_Type_create_struct
  postPatch = ''
    substituteInPlace hpl/src/comm/HPL_packL.c \
      --replace-fail "MPI_Address" "MPI_Get_address" \
      --replace-fail "MPI_Type_struct" "MPI_Type_create_struct"
  '';

  nativeBuildInputs = [ gfortran ];

  buildInputs = [
    mpi
    blas
    lapack
  ];

  postUnpack = ''
    cat > $sourceRoot/hpl/Make.nix << 'MAKEFILE'
    SHELL        = /bin/sh
    CD           = cd
    CP           = cp
    LN_S         = ln -s
    MKDIR        = mkdir
    RM           = /bin/rm -f
    TOUCH        = touch
    ARCH         = nix
    TOPdir       = ../../..
    INCdir       = $(TOPdir)/include
    BINdir       = $(TOPdir)/bin/$(ARCH)
    LIBdir       = $(TOPdir)/lib/$(ARCH)
    HPLlib       = $(LIBdir)/libhpl.a
    MAKEFILE
    cat >> $sourceRoot/hpl/Make.nix << EOF
    MPdir        = ${mpiDev}
    MPinc        = -I\$(MPdir)/include
    MPlib        = -L${lib.getLib mpi}/lib -lmpi
    LAdir        = ${lapack}/lib
    LAinc        =
    LAlib        = -L${blas}/lib -L${lapack}/lib -L${gfortran.cc.lib}/lib -lblas -llapack -lgfortran -lm
    F2CDEFS      =
    HPL_INCLUDES = -I\$(INCdir) -I\$(INCdir)/\$(ARCH) \$(LAinc) \$(MPinc)
    HPL_LIBS     = \$(HPLlib) \$(LAlib) \$(MPlib)
    HPL_OPTS     = -DHPL_CALL_CBLAS
    HPL_DEFS     = \$(F2CDEFS) \$(HPL_OPTS) \$(HPL_INCLUDES)
    CC           = ${mpiDev}/bin/mpicc
    CCNOOPT      = \$(HPL_DEFS)
    CCFLAGS      = \$(HPL_DEFS) -O3
    LINKER       = ${mpiDev}/bin/mpicc
    LINKFLAGS    = \$(CCFLAGS)
    ARCHIVER     = ar
    ARFLAGS      = r
    RANLIB       = ranlib
    EOF
  '';

  makeFlags = [ "arch=nix" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 hpcc $out/bin/hpcc
    install -Dm644 _hpccinf.txt $out/share/hpcc/hpccinf.txt

    runHook postInstall
  '';

  meta = {
    description = "HPC Challenge Benchmark";
    longDescription = ''
      HPCC is a benchmark suite that measures a range of memory access
      patterns. It includes HPL (High Performance Linpack), DGEMM,
      STREAM, PTRANS, RandomAccess, FFT, and communication bandwidth
      and latency benchmarks. It is used to stress test and compare
      high performance computing systems.
    '';
    homepage = "https://hpcchallenge.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ spaghetti-stack ];
    mainProgram = "hpcc";
  };
})
