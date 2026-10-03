{
  antlr2,
  coreutils,
  curl,
  fetchFromGitHub,
  flex,
  gsl,
  lib,
  libtool,
  netcdf,
  netcdfcxx4,
  stdenv,
  udunits,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nco";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "nco";
    repo = "nco";
    tag = finalAttrs.version;
    hash = "sha256-5yavmrv3j+a1SuuQ16jJ/Z5E0enOr8+jEFi30vEO/LI=";
  };

  nativeBuildInputs = [
    antlr2
    flex
    which
  ];

  buildInputs = [
    coreutils
    curl
    gsl
    netcdf
    netcdfcxx4
    udunits
  ];

  postPatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"

    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  # fixes libm.so.6: error adding symbols: DSO missing from command line
  NIX_LDFLAGS = "-lm";

  makeFlags = lib.optionals stdenv.hostPlatform.isDarwin [ "LIBTOOL=${libtool}/bin/libtool" ];

  enableParallelBuilding = true;

  meta = {
    description = "NetCDF Operator toolkit";
    homepage = "https://nco.sourceforge.net/";
    license = lib.licenses.bsd3;
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.unix;
  };
})
