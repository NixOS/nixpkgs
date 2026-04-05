{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  gfortran,
  zlib,
  libaec,
  mpi,
  jdk,
  testers,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  cppSupport ? !(mpiSupport || threadsafe),
  fortranSupport ? false,
  mpiSupport ? false,
  javaSupport ? false,
  threadsafe ? false,
  allowUnsupported ? false,
  apiVersion ? "v200",
}:

assert (cppSupport && mpiSupport) -> allowUnsupported;
assert (threadsafe && (cppSupport || fortranSupport || mpiSupport)) -> allowUnsupported;

# See https://github.com/HDFGroup/hdf5/blob/develop/CMakeLists.txt
# for valid versions
assert lib.elem apiVersion [
  "v16"
  "v18"
  "v110"
  "v112"
  "v114"
  "v200"
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

  # make build reproducible, note CMAKE_HOST_SYSTEM a read-only internal variable
  # and we cannot override it via CMAKE variables
  postPatch = ''
    substituteInPlace src/H5build_settings.cmake.c.in src/libhdf5.settings.in \
      --replace-fail "@CMAKE_HOST_SYSTEM@" ""
  '';

  nativeBuildInputs = [
    removeReferencesTo
    cmake
  ]
  ++ lib.optional fortranSupport gfortran;

  buildInputs = lib.optional javaSupport jdk;

  propagatedBuildInputs = [
    zlib
    libaec
  ]
  ++ lib.optional mpiSupport mpi;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "HDF5_BUILD_WITH_INSTALL_NAME" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "HDF5_BUILD_CPP_LIB" cppSupport)
    (lib.cmakeBool "HDF5_BUILD_FORTRAN" fortranSupport)
    (lib.cmakeBool "HDF5_BUILD_HL_LIB" (!threadsafe))
    (lib.cmakeBool "HDF5_BUILD_JAVA" javaSupport)
    (lib.cmakeBool "HDF5_ENABLE_SZIP_SUPPORT" true)
    (lib.cmakeBool "HDF5_ENABLE_ZLIB_SUPPORT" true)
    (lib.cmakeBool "HDF5_ENABLE_PARALLEL" mpiSupport)
    (lib.cmakeBool "HDF5_ENABLE_THREADSAFE" threadsafe)
    (lib.cmakeBool "HDF5_ALLOW_UNSUPPORTED" allowUnsupported)
    (lib.cmakeFeature "HDF5_DEFAULT_API_VERSION" apiVersion)
    (lib.cmakeFeature "HDF5_INSTALL_CMAKE_DIR" "lib/cmake/hdf5")
  ];

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
  '';

  passthru = {
    inherit
      cppSupport
      fortranSupport
      mpiSupport
      mpi
      ;

    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [ "hdf5" ];
        versionCheck = true;
      };
      cmake-config = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [ "hdf5" ];
        versionCheck = true;
      };
    };
  };

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = lib.licenses.bsd3Lbnl;
    maintainers = [ lib.maintainers.markuskowa ];
    homepage = "https://www.hdfgroup.org/HDF5/";
    platforms = lib.platforms.unix;
  };
})
