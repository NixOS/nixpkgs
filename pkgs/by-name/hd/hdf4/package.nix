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
  version = "4.2.15";

  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF/releases/HDF${finalAttrs.version}/src/hdf-${finalAttrs.version}.tar.bz2";
    hash = "sha256-veA171oc1f29Cn8fpcF+mLvVmTABiaxNI08W6bt7yxI=";
  };

  patches = [
    # Note that the PPC, SPARC and s390 patches are only needed so the aarch64 patch applies cleanly
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-ppc.patch";
      hash = "sha256-AEsj88VzWtyZRk2nFWV/hLD/A2oPje38T/7jvfV1azU=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-4.2.4-sparc.patch";
      hash = "sha256-EKuUQ1m+/HWTFYmkTormtQATDj0rHlQpI4CoK1m+5EY=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-s390.patch";
      hash = "sha256-Ix6Ft+enNHADXFeRTDNijqU9XWmSEz/y8CnQoEleOCo=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-arm.patch";
      hash = "sha256-gytMtvpvR1nzV1NncrYc0yz1ZlBku1AT6sPdubcK85Q=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-aarch64.patch";
      hash = "sha256-eu+M3UbgI2plJNblAT8hO1xBXbfco6jX8iZMGjXbWoQ=";
    })
    ./darwin-aarch64.patch
  ];

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
    maintainers = with maintainers; [ knedlsepp ];
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
})
