{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  cppSupport ? true,
  fortranSupport ? false,
  gfortran,
  zlibSupport ? true,
  zlib,
  szipSupport ? false,
  szip,
  libaec,
  mpiSupport ? false,
  mpi,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  javaSupport ? false,
  jdk,
  threadsafe ? false,
  apiVersion ? "v200",
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

  passthru = {
    inherit
      cppSupport
      fortranSupport
      gfortran
      zlibSupport
      zlib
      szipSupport
      szip
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

  buildInputs =
    lib.optionals szipSupport [
      szip
      libaec
    ]
    ++ lib.optional javaSupport jdk;

  propagatedBuildInputs = lib.optional zlibSupport zlib ++ lib.optional mpiSupport mpi;

  cmakeFlags = [
    "-DHDF5_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake"
    "-DBUILD_STATIC_LIBS=${lib.boolToString enableStatic}"
    "-DDEFAULT_API_VERSION=${apiVersion}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DHDF5_BUILD_WITH_INSTALL_NAME=ON"
  ++ lib.optional cppSupport "-DHDF5_BUILD_CPP_LIB=ON"
  ++ lib.optional fortranSupport "-DHDF5_ENABLE_FORTRAN=ON"
  ++ lib.optional szipSupport "-DHDF5_ENABLE_SZIP_SUPPORT=ON"
  ++ lib.optional zlibSupport "-DHDF5_ENABLE_ZLIB_SUPPORT=ON"
  ++ lib.optionals mpiSupport [ "-DHDF5_ENABLE_PARALLEL=ON" ]
  ++ lib.optional enableShared "-DBUILD_SHARED_LIBS=ON"
  ++ lib.optional javaSupport "-DHDF5_BUILD_JAVA=ON"
  ++ lib.optionals threadsafe [
    "-DHDF5_ENABLE_THREADSAFE:BOOL=ON"
  ];

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
    moveToOutput 'bin/' "''${!outputBin}"
    moveToOutput 'bin/h5cc' "''${!outputDev}"
    moveToOutput 'bin/h5c++' "''${!outputDev}"
    moveToOutput 'bin/h5fc' "''${!outputDev}"
    moveToOutput 'bin/h5pcc' "''${!outputDev}"
    moveToOutput 'bin/h5hlcc' "''${!outputDev}"
    moveToOutput 'bin/h5hlc++' "''${!outputDev}"
  ''
  +
    lib.optionalString enableShared
      # The shared build creates binaries with -shared suffixes,
      # so we remove these suffixes.
      ''
        pushd ''${!outputBin}/bin
        for file in *-shared; do
          mv "$file" "''${file%%-shared}"
        done
        popd
      '';

  enableParallelBuilding = true;

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
