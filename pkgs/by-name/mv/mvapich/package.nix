{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  removeReferencesTo,
  bison,
  rdma-core,
  libxml2,
  perl,
  gfortran,
  slurm,
  openssh,
  hwloc,
  zlib,
  makeWrapper,
  python3,
  # InfiniBand dependencies
  ucx,
  # OmniPath dependencies
  libfabric,
  # Compile with slurm as a process manager
  useSlurm ? false,
  # Network backend for MVAPICH2
  network ? "ucx",
}:

assert builtins.elem network [
  "ucx"
  "ofi"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "mvapich";
  version = "4.1";

  src = fetchurl {
    url = "https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-JaU9NyW2aeLGSBWPt8n8WxOIlT86L5SXSFhsRH0OQ+4=";
  };

  outputs = [
    "out"
    "dev"
    "benchmarks"
  ];

  nativeBuildInputs = [
    pkg-config
    bison
    makeWrapper
    gfortran
    python3
    removeReferencesTo
  ];

  buildInputs = [
    libxml2
    perl
    openssh
    hwloc
    zlib
  ]
  ++ lib.optionals (network == "ucx") [
    ucx
  ]
  ++ lib.optionals (network == "ofi") [
    rdma-core
    libfabric
  ]
  ++ lib.optional useSlurm slurm;

  configureFlags = [
    "--with-pm=hydra"
    "--enable-fortran=all"
    "--enable-cxx"
    "--enable-threads=multiple"
    "--enable-hybrid"
    "--enable-shared"
  ]
  ++ lib.optionals (network == "ucx") [
    "--with-device=ch4:ucx"
  ]
  ++ lib.optionals (network == "ofi") [
    "--with-device=ch4:ofi"
  ];

  doCheck = false; # requries bindir/bin/mpicc before install is run

  postInstall = ''
    for e in mpif77 mpif90 mpifort mpichversion mpic++ mpicxx mpicc mpivars; do
      moveToOutput "bin/$e" "''${!outputDev}"
    done

    mkdir -p $benchmarks
    moveToOutput "libexec/osu-micro-benchmarks/" $benchmarks
  '';

  # Ensure the default compilers are the ones mvapich was built with
  preFixup = ''
    substituteInPlace $dev/bin/mpicc --replace-fail 'CC="gcc"' 'CC=${stdenv.cc}/bin/cc'
    substituteInPlace $dev/bin/mpicxx --replace-fail 'CXX="g++"' 'CXX=${stdenv.cc}/bin/c++'
    substituteInPlace $dev/bin/mpifort --replace-fail 'FC="gfortran"' 'FC=${gfortran}/bin/gfortran'

  '';

  postFixup = ''
    for e in mpi mpifort mpicxx; do
      remove-references-to -t "''${!outputDev}" $(readlink -f $out/lib/lib$e${stdenv.hostPlatform.extensions.library})
    done

    if [ -e $out/bin/mpiexec.hydra ]; then
      remove-references-to -t "''${!outputDev}" $out/bin/mpiexec.hydra
    fi
  '';

  enableParallelBuilding = true;

  meta = {
    description = "MPI-3.1 implementation optimized for Infiband and OmniPath transport";
    homepage = "https://mvapich.cse.ohio-state.edu";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux;
  };
})
