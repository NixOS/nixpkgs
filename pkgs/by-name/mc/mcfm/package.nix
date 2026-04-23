{
  lib,
  fetchurl,
  cmake,
  gfortran,
  gccStdenv,
  lhapdf,
}:
let
  stdenv = gccStdenv;
  lhapdf' = lhapdf.override {
    stdenv = gccStdenv;
    python3 = null;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "MCFM";
  version = "10.0.1";

  src = fetchurl {
    url = "https://mcfm.fnal.gov/downloads/MCFM-${finalAttrs.version}.tar.gz";
    hash = "sha256-3Dg4KoILb0XhgGkzItDh/1opCtYrrIvtbuALYqPUvE8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'target_link_libraries(mcfm lhapdf_lib)' \
                'target_link_libraries(mcfm ''${lhapdf_lib})'

    substituteInPlace qcdloop-2.0.5/CMakeLists.txt \
    --replace-fail 'cmake_minimum_required (VERSION 3.0.2)' \
    'cmake_minimum_required (VERSION 3.15)'
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];
  buildInputs = [ lhapdf' ];

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
