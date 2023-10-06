{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, boost
, cmake
, doxygen
, gtest
, leveldb
, lomiri
, pkg-config
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "persistent-cache-cpp";
  version = "1.0.5";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/persistent-cache-cpp";
    rev = finalAttrs.version;
    hash = "sha256-MOH8ardiTliTKrtRQ5eFRhbRtnC0Yq20WJYoo1tAn3E=";
  };

  patches = [
    # Fix build on GCC 12
    # Remove when version > 1.0.5
    (fetchpatch {
      url = "https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/commit/3ed84ee1d32a27d183de2cb5f9feffc3f48fd9a1.patch";
      hash = "sha256-aNZ6KVHAsLVYlAcPNNkjUlOPRDZxzN5tzk4/1KuVaSY=";
    })

    # Fix build on current Boost
    # Remove when version > 1.0.5
    (fetchpatch {
      url = "https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/commit/a590ffcccec252caa7b19a2922c678502069b057.patch";
      hash = "sha256-OhlsnUVhclt17brkncYkJ0+lXrJO671mtwopaAGPrtY=";
    })

    # PersistentStringCacheImpl.exceptions test fails on LLVM's libcxx, it depends on std::system_error producing a very specific exception text
    # Expects "Unknown error 666", gets "unspecified generic_category error"
    # https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/blob/1.0.5/tests/core/internal/persistent_string_cache_impl/persistent_string_cache_impl_test.cpp?ref_type=tags#L1298
    ./0001-persistent-cache-cpp-Lenient-exception-test-matching.patch
  ];

  postPatch = ''
    # Wrong concatenation
    substituteInPlace data/libpersistent-cache-cpp.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib"

    # Runs in parallel to other tests, limit to 1 thread
    substituteInPlace tests/headers/compile_headers.py \
      --replace 'multiprocessing.cpu_count()' '1'
  '' + (if finalAttrs.doCheck then ''
    patchShebangs tests/{headers,whitespace}/*.py
  '' else ''
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '');

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    boost
    lomiri.cmake-extras
  ];

  propagatedBuildInputs = [
    leveldb
  ];

  nativeCheckInputs = [
    python3
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    # error: 'old_version' may be used uninitialized
    "-DWerror=OFF"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Cache of key-value pairs with persistent storage for C++ 11";
    longDescription = ''
      A persistent cache for arbitrary (possibly large amount of data, such as
      image files) that is fast, scalable, and crash-proof.
    '';
    homepage = "https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.unix;
    pkgConfigModules = [
      "libpersistent-cache-cpp"
    ];
  };
})
