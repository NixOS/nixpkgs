{
  lib,
  stdenv,
  fetchurl,
  cmake,
  gfortran,
  lhapdf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "MCFM";
  version = "10.3";

  src = fetchurl {
    url = "https://mcfm.fnal.gov/downloads/MCFM-${finalAttrs.version}.tar.gz";
    hash = "sha256-l2d8vMsGsoIaX6FWnR9WGyU70GUal6sF0TJHxwiGSEA=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [ lhapdf ];

  cmakeFlags = [
    "-Duse_external_lhapdf=ON"
    "-Duse_internal_lhapdf=OFF"
  ];

  meta = {
    description = "Monte Carlo for FeMtobarn processes";
    homepage = "https://mcfm.fnal.gov";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ veprbl ];
    platforms = lib.platforms.x86_64;
  };
})
