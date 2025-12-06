{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  bison,
  numactl,
  libxml2,
  perl,
  gfortran,
  openssh,
  hwloc,
  zlib,
  ucx,
  makeWrapper,
  # InfiniBand adependencies
  rdma-core,
  opensm,
  # OmniPath dependencies
  libpsm2,
  libfabric,
  # Network type for MVAPICH2
  network ? "ethernet",
}:

assert builtins.elem network [
  "ethernet"
  "infiniband"
  "omnipath"
];

stdenv.mkDerivation rec {
  pname = "mvapich";
  version = "4.1";

  src = fetchurl {
    url = "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich-${version}.tar.gz";
    hash = "sha256-JaU9NyW2aeLGSBWPt8n8WxOIlT86L5SXSFhsRH0OQ+4=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    pkg-config
    bison
    makeWrapper
    gfortran
    python3
  ];
  propagatedBuildInputs = [
    numactl
    rdma-core
    zlib
    opensm
  ];
  buildInputs = [
    numactl
    libxml2
    perl
    openssh
    hwloc
  ]
  ++ lib.optionals (network == "ethernet" || network == "infiniband") [
    ucx
    rdma-core
  ]
  ++ lib.optionals (network == "omnipath") [
    libpsm2
    libfabric
  ];

  configureFlags = [
    "--with-pm=hydra"
    "--enable-fortran=all"
    "--enable-cxx"
    "--enable-threads=multiple"
    "--enable-hybrid"
    "--enable-shared"
    "FFLAGS=-fallow-argument-mismatch" # fix build with gfortran 10
  ]
  ++ lib.optionals (network == "ethernet" || network == "infiniband") [
    "--with-device=ch4:ucx"
    "--with-ucx=${ucx}"
  ]
  ++ lib.optionals (network == "omnipath") [
    "--with-device=ch4:ofi"
  ];

  doCheck = false;

  preFixup = ''
    # /tmp/nix-build... ends up in the RPATH, fix it manually
    for entry in $out/bin/mpichversion $out/bin/mpivars; do
      echo "fix rpath: $entry"
      patchelf --allowed-rpath-prefixes ${builtins.storeDir} --shrink-rpath $entry
    done

    # Ensure the default compilers are the ones mvapich was built with
    substituteInPlace $out/bin/mpicc --replace 'CC="gcc"' 'CC=${stdenv.cc}/bin/cc'
    substituteInPlace $out/bin/mpicxx --replace 'CXX="g++"' 'CXX=${stdenv.cc}/bin/c++'
    substituteInPlace $out/bin/mpifort --replace 'FC="gfortran"' 'FC=${gfortran}/bin/gfortran'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "MPI-3.1 implementation optimized for Infiband transport";
    homepage = "https://mvapich.cse.ohio-state.edu";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
