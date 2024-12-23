{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  fixDarwinDylibNames,
  cmake,
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
  version = "4.2.16-2";

  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF/releases/HDF${finalAttrs.version}/src/hdf-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xcMjS1ASJYrvLkQy9kmzHCGyYBWvuhhXrYNkDD8raSw=";
  };

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      fixDarwinDylibNames
    ]
    ++ lib.optional fortranSupport gfortran;

  buildInputs =
    [
      libjpeg
      zlib
    ]
    ++ lib.optional javaSupport jdk
    ++ lib.optional szipSupport szip
    ++ lib.optional uselibtirpc libtirpc;

  preConfigure =
    lib.optionalString uselibtirpc ''
      # Make tirpc discovery work with CMAKE_PREFIX_PATH
      substituteInPlace config/cmake/FindXDR.cmake \
        --replace-fail 'find_path(XDR_INCLUDE_DIR NAMES rpc/types.h PATHS "/usr/include" "/usr/include/tirpc")' \
                       'find_path(XDR_INCLUDE_DIR NAMES rpc/types.h PATH_SUFFIXES include/tirpc)'
    ''
    + lib.optionalString szipSupport ''
      export SZIP_INSTALL=${szip}
    '';

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
      (lib.cmakeBool "HDF4_BUILD_TOOLS" true)
      (lib.cmakeBool "HDF4_BUILD_UTILS" true)
      (lib.cmakeBool "HDF4_BUILD_WITH_INSTALL_NAME" false)
      (lib.cmakeBool "HDF4_ENABLE_JPEG_LIB_SUPPORT" true)
      (lib.cmakeBool "HDF4_ENABLE_Z_LIB_SUPPORT" true)
      (lib.cmakeBool "HDF4_ENABLE_NETCDF" netcdfSupport)
      (lib.cmakeBool "HDF4_BUILD_FORTRAN" fortranSupport)
      (lib.cmakeBool "HDF4_ENABLE_SZIP_SUPPORT" szipSupport)
      (lib.cmakeBool "HDF4_ENABLE_SZIP_ENCODING" szipSupport)
      (lib.cmakeBool "HDF4_BUILD_JAVA" javaSupport)
      (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
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

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
    ];
  };

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  excludedTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "MFHDF_TEST-hdftest"
    "MFHDF_TEST-hdftest-shared"
    "HDP-dumpsds-18"
    "NC_TEST-nctest"
  ];

  checkPhase =
    let
      excludedTestsRegex = lib.optionalString (
        finalAttrs.excludedTests != [ ]
      ) "(${lib.concatStringsSep "|" finalAttrs.excludedTests})";
    in
    ''
      runHook preCheck
      ctest -E "${excludedTestsRegex}" --output-on-failure
      runHook postCheck
    '';

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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
})
