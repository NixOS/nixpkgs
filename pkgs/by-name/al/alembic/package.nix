{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openexr,
  hdf5-threadsafe,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alembic";
  version = "1.8.12";

  src = fetchFromGitHub {
    owner = "alembic";
    repo = "alembic";
    tag = finalAttrs.version;
    hash = "sha256-cH/hfGnl037Q2kWzGz68RZW9MOqU/M2I+/osyyGlN/s=";
  };

  # note: out is unused (but required for outputDoc anyway)
  outputs = [
    "bin"
    "dev"
    "out"
    "lib"
  ];

  # Prevent cycle between bin and dev (only occurs on Darwin for some reason)
  propagatedBuildOutputs = [ "lib" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openexr
    hdf5-threadsafe
  ];

  # These flags along with the postPatch step ensure that all artifacts end up
  # in the correct output without needing to move anything
  #
  # - bin: Uses CMAKE_INSTALL_BINDIR (set via CMake setup hooK)
  # - lib (contains shared libraries): Uses ALEMBIC_LIB_INSTALL_DIR
  # - dev (headers): Uses CMAKE_INSTALL_PREFIX
  #   (this works because every other install rule uses an absolute DESTINATION)
  # - dev (CMake files): Uses ConfigPackageLocation

  cmakeFlags = [
    "-DUSE_HDF5=ON"
    "-DUSE_TESTS=ON"
    "-DALEMBIC_LIB_INSTALL_DIR=${placeholder "lib"}/lib"
    "-DConfigPackageLocation=${placeholder "dev"}/lib/cmake/Alembic"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "dev"}"
    "-DQUIET=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Upstream defaults the dylib's install RPATH to $dev/..., embedding a $dev
    # path in the $lib output and cycling with the CMake config in $dev. Linux
    # is spared by patchelf --shrink-rpath; Darwin has no such step. Overriding
    # the (guarded) default to the real lib dir breaks the cycle without a patch.
    "-DCMAKE_INSTALL_RPATH=${placeholder "lib"}/lib"
  ];

  postPatch = ''
    find bin/ -type f -name CMakeLists.txt -print -exec \
      sed -i 's/INSTALL(TARGETS \([a-zA-Z ]*\) DESTINATION bin)/INSTALL(TARGETS \1)/' {} \;
  '';

  doCheck = true;
  enableParallelChecking = false;

  meta = {
    description = "Open framework for storing and sharing scene data";
    homepage = "http://alembic.io/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      guibou
      tmarkus
    ];
  };
})
