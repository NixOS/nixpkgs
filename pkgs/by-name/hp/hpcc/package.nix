{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  mpi,
  blas,
  lapack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpcc";
  version = "1.5.0";

  src = fetchurl {
    url = "https://hpcchallenge.org/projectsfiles/hpcc/download/hpcc-${finalAttrs.version}.tar.gz";
    hash = "sha256-Cm/vernzNH5Un+1l67mCNP7qnuGK6gyPWbrvvjz3/7g=";
  };

  # HPCC uses MPI-1 standard: Fix compatibility with MPI-3.
  # MPI_Address -> MPI_Get_address, MPI_Type_struct -> MPI_Type_create_struct.
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
    gfortran.cc.lib
  ];

  # HPCC bundles HPL 2.0 which does not have autotools, and instead requires a Make.<arch> file.
  # See the INSTALL readme of HPCC: https://github.com/icl-utk-edu/hpcc/blob/main/hpl/INSTALL .
  postUnpack = ''
    cat > $sourceRoot/hpl/Make.nixpkgs << 'MAKEFILE'
    SHELL        = /bin/sh
    CD           = cd
    CP           = cp
    LN_S         = ln -s
    MKDIR        = mkdir -p
    RM           = /bin/rm -f
    TOUCH        = touch
    ARCH         = nixpkgs
    TOPdir       = ../../..
    INCdir       = $(TOPdir)/include
    BINdir       = $(TOPdir)/bin/$(ARCH)
    LIBdir       = $(TOPdir)/lib/$(ARCH)
    HPLlib       = $(LIBdir)/libhpl.a
    MPinc        =
    MPlib        = -lmpi
    LAlib        = -lblas -llapack -lgfortran -lm
    HPL_INCLUDES = -I$(INCdir) -I$(INCdir)/$(ARCH) $(MPinc)
    HPL_LIBS     = $(HPLlib) $(LAlib) $(MPlib)
    HPL_OPTS     = -DHPL_CALL_CBLAS
    HPL_DEFS     = $(HPL_OPTS) $(HPL_INCLUDES)
    CC           = mpicc
    CCNOOPT      = $(HPL_DEFS)
    CCFLAGS      = $(HPL_DEFS) -O3
    LINKER       = mpicc
    LINKFLAGS    = $(CCFLAGS)
    ARCHIVER     = ar
    ARFLAGS      = r
    RANLIB       = ranlib
    MAKEFILE
  '';

  makeFlags = [ "arch=nixpkgs" ];

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

      Note: HPCC bundles older versions of these benchmarks (HPL 2.0,
      MPI-1). For new deployments, consider using the
      standalone packages.
    '';
    homepage = "https://hpcchallenge.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ spaghetti-stack ];
    mainProgram = "hpcc";
  };
})
