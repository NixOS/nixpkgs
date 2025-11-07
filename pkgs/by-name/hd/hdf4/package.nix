{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libjpeg,
  uselibtirpc ? stdenv.hostPlatform.isLinux,
  libtirpc,
  zlib,
  szipSupport ? false,
  szip,
  javaSupport ? false,
  jdk,
  fortranSupport ? false,
  gfortran,
  netcdfSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdf";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "HDFGroup";
    repo = "hdf4";
    tag = "hdf${finalAttrs.version}";
    hash = "sha256-Q2VKwkp/iroStrOnwHI8d/dtMWkMoJesBVBVChwNa30=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optional fortranSupport gfortran;

  buildInputs = [
    libjpeg
    zlib
  ]
  ++ lib.optional javaSupport jdk
  ++ lib.optional szipSupport szip
  ++ lib.optional uselibtirpc libtirpc;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "HDF4_BUILD_TOOLS" true)
    (lib.cmakeBool "HDF4_BUILD_UTILS" true)
    (lib.cmakeBool "HDF4_BUILD_WITH_INSTALL_NAME" true)
    (lib.cmakeBool "HDF4_ENABLE_JPEG_LIB_SUPPORT" true)
    (lib.cmakeBool "HDF4_ENABLE_Z_LIB_SUPPORT" true)
    (lib.cmakeBool "HDF4_ENABLE_NETCDF" netcdfSupport)
    (lib.cmakeBool "HDF4_BUILD_FORTRAN" fortranSupport)
    (lib.cmakeBool "HDF4_ENABLE_SZIP_SUPPORT" szipSupport)
    (lib.cmakeBool "HDF4_ENABLE_SZIP_ENCODING" szipSupport)
    (lib.cmakeBool "HDF4_BUILD_JAVA" javaSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals javaSupport [
    (lib.cmakeFeature "JAVA_HOME" "${jdk}")
  ]
  ++ lib.optionals fortranSupport [
    (lib.cmakeFeature "CMAKE_Fortran_FLAGS" "-fallow-argument-mismatch")
  ]
  # using try_run would set these, but that requires a cross-compiling emulator to be available
  # instead, we mark them as if the try_run calls returned a non-zero exit code
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    (lib.cmakeFeature "TEST_LFS_WORKS_RUN" "1")
    (lib.cmakeFeature "H4_PRINTF_LL_TEST_RUN" "1")
    (lib.cmakeFeature "H4_PRINTF_LL_TEST_RUN__TRYRUN_OUTPUT" "")
  ];

  doCheck = true;

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  postInstall = ''
    moveToOutput bin "$bin"
  '';

  passthru = {
    inherit
      uselibtirpc
      libtirpc
      szipSupport
      szip
      javaSupport
      jdk
      ;
  };

  meta = with lib; {
    description = "Data model, library, and file format for storing and managing data";
    homepage = "https://support.hdfgroup.org/products/hdf4/";
    maintainers = [ ];
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
})
