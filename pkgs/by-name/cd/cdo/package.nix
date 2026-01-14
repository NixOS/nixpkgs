{
  lib,
  stdenv,
  fetchurl,
  curl,
  hdf5,
  netcdf,
  eccodes,
  python3,
  # build, install and link to a CDI library [default=no]
  enable_cdi_lib ? false,
  # build a completely statically linked CDO binary
  enable_all_static ? stdenv.hostPlatform.isStatic,
  # Use CXX as default compiler [default=no]
  enable_cxx ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdo";
  version = "2.5.1";

  src = fetchurl {
    url = "https://code.mpimet.mpg.de/attachments/download/29864/cdo-${finalAttrs.version}.tar.gz";
    hash = "sha256-QYv5HoZMv+VHw8jhUNMUGc+nFefTRVCMVZGxq9pUV9E=";
  };

  # Dependencies
  buildInputs = [
    curl
    netcdf
    hdf5
    python3
  ];

  configureFlags = [
    "--with-netcdf=${netcdf}"
    "--with-hdf5=${hdf5}"
    "--with-eccodes=${eccodes}"
  ]
  ++ lib.optional enable_cdi_lib "--enable-cdi-lib"
  ++ lib.optional enable_all_static "--enable-all-static"
  ++ lib.optional enable_cxx "--enable-cxx";

  meta = {
    description = "Collection of command line Operators to manipulate and analyse Climate and NWP model Data";
    mainProgram = "cdo";
    longDescription = ''
      Supported data formats are GRIB 1/2, netCDF 3/4, SERVICE, EXTRA and IEG.
      There are more than 600 operators available.
    '';
    homepage = "https://code.mpimet.mpg.de/projects/cdo/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ltavard ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
