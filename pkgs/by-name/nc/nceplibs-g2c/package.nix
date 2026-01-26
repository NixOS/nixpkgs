{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libjpeg,
  jasper,
  libpng,
  libz,
  openjpeg,
  libaec,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nceplibs-g2c";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "NOAA-EMC";
    repo = "NCEPLIBS-g2c";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sIijCmmSy9SXvN31mbX5pJA6mNX3PrLbQWFC5ar5IUg=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libjpeg
    jasper
    libpng
    libz
    libaec
  ];

  meta = {
    description = "C decoder/encoder routines for GRIB edition 2";
    homepage = "https://github.com/NOAA-EMC/NCEPLIBS-g2c";
    longDescription = ''
      This library contains C decoder/encoder routines for GRIB edition 2.

      GRIdded Binary or General Regularly-distributed Information in Binary form
      (GRIB) is a data format for meteorological and forecast data, standardized
      by the World Meteorological Organization (WMO). GRIB edition 2 (GRIB2) was
      approved by the WMO is 2003.

      The NCEPLIBS-g2c library is used by wgrib2, grib2io, GRaDS, and Model
      Evaluation Tools (MET) projects, among others.
    '';
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.kqr ];
  };
})
