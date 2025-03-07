{
  lib,
  stdenv,
  fetchurl,
  cmake,
  gfortran,
  lhapdf,
}:

stdenv.mkDerivation rec {
  pname = "MCFM";
  version = "10.0.1";

  src = fetchurl {
    url = "https://mcfm.fnal.gov/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-3Dg4KoILb0XhgGkzItDh/1opCtYrrIvtbuALYqPUvE8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'target_link_libraries(mcfm lhapdf_lib)' \
                'target_link_libraries(mcfm ''${lhapdf_lib})'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];
  buildInputs = [ lhapdf ];

  cmakeFlags = [
    "-Duse_external_lhapdf=ON"
    "-Duse_internal_lhapdf=OFF"
  ];

  meta = with lib; {
    description = "Monte Carlo for FeMtobarn processes";
    homepage = "https://mcfm.fnal.gov";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veprbl ];
    platforms = lib.platforms.x86_64;
  };
}
