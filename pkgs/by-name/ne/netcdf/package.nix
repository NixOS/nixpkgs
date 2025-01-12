{
  lib,
  stdenv,
  fetchurl,
  unzip,
  hdf5,
  bzip2,
  libzip,
  zstd,
  szipSupport ? false,
  szip,
  libxml2,
  m4,
  curl, # for DAP
  removeReferencesTo,
}:

let
  inherit (hdf5) mpiSupport mpi;
in
stdenv.mkDerivation rec {
  pname = "netcdf" + lib.optionalString mpiSupport "-mpi";
  version = "4.9.2";

  src = fetchurl {
    url = "https://downloads.unidata.ucar.edu/netcdf-c/${version}/netcdf-c-${version}.tar.gz";
    hash = "sha256-zxG6u725lj8J9VB54LAZ9tA3H1L44SZKW6jp/asabEg=";
  };

  postPatch = ''
    patchShebangs .

    # this test requires the net
    for a in ncdap_test/Makefile.am ncdap_test/Makefile.in; do
      substituteInPlace $a --replace testurl.sh " "
    done

    # Prevent building the tests from prepending `#!/bin/bash` and wiping out the patched shenbangs.
    substituteInPlace nczarr_test/Makefile.in \
      --replace '#!/bin/bash' '${stdenv.shell}'
  '';

  nativeBuildInputs = [
    m4
    removeReferencesTo
    libxml2 # xml2-config
  ];

  buildInputs = [
    curl
    hdf5
    libxml2
    mpi
    bzip2
    libzip
    zstd
  ] ++ lib.optional szipSupport szip;

  strictDeps = true;

  passthru = {
    inherit mpiSupport mpi;
  };

  env.NIX_CFLAGS_COMPILE =
    # Suppress incompatible function pointer errors when building with newer versions of clang 16.
    # tracked upstream here: https://github.com/Unidata/netcdf-c/issues/2715
    lib.optionalString stdenv.cc.isClang "-Wno-error=incompatible-function-pointer-types";

  configureFlags =
    [
      "--enable-netcdf-4"
      "--enable-dap"
      "--enable-shared"
      "--disable-dap-remote-tests"
      "--with-plugin-dir=${placeholder "out"}/lib/hdf5-plugins"
    ]
    ++ (lib.optionals mpiSupport [
      "--enable-parallel-tests"
      "CC=${lib.getDev mpi}/bin/mpicc"
    ]);

  enableParallelBuilding = true;

  disallowedReferences = [ stdenv.cc ];

  postFixup = ''
    remove-references-to -t ${stdenv.cc} "$(readlink -f $out/lib/libnetcdf.settings)"
  '';

  doCheck = !mpiSupport;
  nativeCheckInputs = [ unzip ];

  preCheck = ''
    export HOME=$TEMP
  '';

  meta = {
    description = "Libraries for the Unidata network Common Data Format";
    platforms = lib.platforms.unix;
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    changelog = "https://docs.unidata.ucar.edu/netcdf-c/${version}/RELEASE_NOTES.html";
    license = lib.licenses.bsd3;
  };
}
