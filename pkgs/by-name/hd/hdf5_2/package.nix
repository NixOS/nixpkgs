{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  gfortran,
  mpi,
  jdk,
  libaec,
  zlib,
  testers,
  ctestCheckHook,
  cppSupport ? true,
  fortranSupport ? false,
  mpiSupport ? false,
  javaSupport ? false,
  threadsafe ? false,
  apiVersion ? null,
}:

# cpp and mpi options are mutually exclusive
# "-DALLOW_UNSUPPORTED=ON" could be used to force the build.
assert !cppSupport || !mpiSupport;

# See https://github.com/HDFGroup/hdf5/blob/develop/CMakeLists.txt
# for valid versions
assert lib.elem apiVersion [
  "v16"
  "v18"
  "v110"
  "v112"
  "v114"
  "v200"
  null
];
let
  enableShared = !stdenv.hostPlatform.isStatic;
  enableStatic = stdenv.hostPlatform.isStatic;
in
stdenv.mkDerivation (finalAttrs: {
  version = "2.2.0";
  pname =
    "hdf5"
    + lib.optionalString cppSupport "-cpp"
    + lib.optionalString fortranSupport "-fortran"
    + lib.optionalString mpiSupport "-mpi"
    + lib.optionalString threadsafe "-threadsafe";

  src = fetchFromGitHub {
    owner = "HDFGroup";
    repo = "hdf5";
    rev = "${finalAttrs.version}";
    hash = "sha256-Tp2f8jJjVst0Fd07Wt4+EzjHRRI+8TlD1uWD9sDTw4g=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./reproducible-build.patch
  ];

  # https://github.com/HDFGroup/hdf5/issues/6791
  postPatch = ''
    substituteInPlace src/CMakeLists.txt fortran/src/CMakeLists.txt c++/src/CMakeLists.txt hl/c++/src/CMakeLists.txt hl/fortran/src/CMakeLists.txt hl/src/CMakeLists.txt \
      --replace-fail '\''${exec_prefix}/''${HDF5_INSTALL_LIB_DIR}' '"''${HDF5_INSTALL_LIB_DIR}"' \
      --replace-fail '\''${prefix}/''${HDF5_INSTALL_INCLUDE_DIR}' '"''${HDF5_INSTALL_LIB_DIR}"'

    # The install prefix variables are a mess and break with abolsute paths,
    # as well as don't seem to know what is what.
    #
    # I'm not confident this is comepletly correct yet, but needs something to
    # use it.
    substituteInPlace config/install/hdf5-config.cmake.in \
      --replace-fail '"@PACKAGE_CURRENT_BUILD_DIR@/bin"' '"${placeholder "bin"}"' \
      --replace-fail "@PACKAGE_SHARE_INSTALL_DIR@" "${placeholder "dev"}/lib/cmake/hdf5"
  '';

  passthru = {
    tests = {
      cmake = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage.dev;
        moduleNames = [
          "hdf5"
        ];
      };
    };
    inherit
      cppSupport
      fortranSupport
      mpiSupport
      mpi
      ;
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    ctestCheckHook
  ]
  ++ lib.optional fortranSupport gfortran;

  buildInputs = lib.optional javaSupport jdk;

  # Need to propagate cmake deps
  propagatedBuildInputs = [
    zlib
    libaec
  ]
  ++ lib.optional mpiSupport mpi;

  cmakeFlags = [
    # https://github.com/HDFGroup/hdf5/blob/fe7f2724301634e7d66cd2f938d4660332c4a803/config/cmake/MemcheckCacheinit.cmake#L16
    # https://github.com/HDFGroup/hdf5/blob/fe7f2724301634e7d66cd2f938d4660332c4a803/CMakeBuildOptions.cmake#L3
    (lib.cmakeBool "HDF5_USE_GNU_DIRS" true)
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "BUILD_STATIC_EXECS" enableStatic)
    (lib.cmakeBool "HDF5_ONLY_SHARED_LIBS" enableShared)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "HDF5_ENABLE_SZIP_SUPPORT" true)
    (lib.cmakeBool "HDF5_ENABLE_ZLIB_SUPPORT" true)
    (lib.cmakeBool "HDF5_BUILD_WITH_INSTALL_NAME" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "HDF5_BUILD_CPP_LIB" cppSupport)
    (lib.cmakeBool "HDF5_BUILD_FORTRAN" fortranSupport)
    (lib.cmakeBool "HDF5_ENABLE_PARALLEL" mpiSupport)
    (lib.cmakeBool "HDF5_BUILD_JAVA" javaSupport)
    (lib.cmakeBool "HDF5_ENABLE_THREADSAFE" threadsafe)
    (lib.cmakeBool "HDF5_BUILD_HL_LIB" (!threadsafe)) # high-level API and threadsafe is unsupported

    # broken in nixpkgs since around 1.14.3 -> 1.14.4.3
    # https://github.com/HDFGroup/hdf5/issues/4208#issuecomment-2098698567
    (lib.cmakeBool "HDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16" (
      with stdenv.hostPlatform; !(isDarwin && isx86_64)
    ))
  ]
  ++ lib.optional (apiVersion != null) (lib.cmakeFeature "HDF5_DEFAULT_API_VERSION" apiVersion);

  doCheck = true;

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      markuskowa
      doronbehar
    ];
    homepage = "https://www.hdfgroup.org/HDF5/";
    platforms = lib.platforms.unix;
  };
})
