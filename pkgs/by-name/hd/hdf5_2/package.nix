{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  libaec,
  zlib,
  cppSupport ? true,
  fortranSupport ? false,
  gfortran,
  mpiSupport ? false,
  mpi,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  javaSupport ? false,
  jdk,
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

stdenv.mkDerivation (finalAttrs: {
  version = "2.1.1";
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
    hash = "sha256-vhsBjOQgzvz6+RbPrR6rRFBXFGkWJNCFjdzWFbu1/ik=";
  };

  patches = [ ./reproducible-build.patch ];

  passthru = {
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
    removeReferencesTo
    cmake
  ]
  ++ lib.optional fortranSupport gfortran;

  buildInputs = [
    libaec
    zlib
  ]
  ++ lib.optional javaSupport jdk;

  propagatedBuildInputs = lib.optional mpiSupport mpi;

  cmakeFlags = [
    # (lib.cmakeBool "HDF5_USE_GNU_DIRS" true)
    (lib.cmakeFeature "HDF5_INSTALL_CMAKE_DIR" "${placeholder "dev"}/lib/cmake")
    (lib.cmakeFeature "HDF5_INSTALL_INCLUDE_DIR" "${placeholder "dev"}/include")
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "HDF5_ENABLE_SZIP_SUPPORT" true)
    (lib.cmakeBool "HDF5_ENABLE_ZLIB_SUPPORT" true)
    (lib.cmakeBool "HDF5_ENABLE_SZIP_ENCODING" true)
    (lib.cmakeBool "HDF5_BUILD_WITH_INSTALL_NAME" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "HDF5_BUILD_CPP_LIB" cppSupport)
    (lib.cmakeBool "HDF5_ENABLE_FORTRAN" fortranSupport)
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

  postInstall = ''
    moveToOutput 'bin/' "''${!outputBin}"
  '';

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.markuskowa ];
    homepage = "https://www.hdfgroup.org/HDF5/";
    platforms = lib.platforms.unix;
  };
})
