{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  netcdf,
  nifticlib,
  hdf5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libminc";
  version = "2.4.07";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "libminc";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-F5c0S4fybkrdpDJQ0nz6MvTdjq1qM1nJVxXuxXbCeSI=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    nifticlib
  ];
  propagatedBuildInputs = [
    netcdf
    hdf5
  ];

  cmakeFlags = [
    "-DLIBMINC_MINC1_SUPPORT=ON"
    "-DLIBMINC_BUILD_SHARED_LIBS=ON"
    "-DLIBMINC_USE_NIFTI=ON"
    "-DLIBMINC_USE_SYSTEM_NIFTI=ON"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  # -j1: see https://github.com/BIC-MNI/libminc/issues/110
  checkPhase = ''
    ctest -j1 --output-on-failure
  '';

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/libminc";
    description = "Medical imaging library based on HDF5";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
})
