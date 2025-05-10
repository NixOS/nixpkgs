{
  lib,
  stdenv,
  fetchFromGitHub,
  netcdf,
  hdf5,
  curl,
  gfortran,
}:
stdenv.mkDerivation rec {
  pname = "netcdf-fortran";
  version = "4.4.5";

  src = fetchFromGitHub {
    owner = "Unidata";
    repo = "netcdf-fortran";
    rev = "v${version}";
    sha256 = "sha256-nC93NcA4VJbrqaLwyhjP10j/t6rQSYcAzKBxclpZVe0=";
  };

  nativeBuildInputs = [ gfortran ];
  buildInputs = [
    netcdf
    hdf5
    curl
  ];

  doCheck = true;

  FFLAGS = [ "-std=legacy" ];
  FCFLAGS = [ "-std=legacy" ];

  meta = with lib; {
    description = "Fortran API to manipulate netcdf files";
    mainProgram = "nf-config";
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    license = licenses.free;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
