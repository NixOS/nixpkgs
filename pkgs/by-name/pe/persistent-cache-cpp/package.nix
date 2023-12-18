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
  version = "1.0.6";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lib-cpp/persistent-cache-cpp";
    rev = finalAttrs.version;
    hash = "sha256-RLZiYY0Y9LT+ajM4Va4MpVVDBlu2yvCpn8bNGMB8ydo=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  patches = [
    # Version in CMakeLists.txt didn't get bumped, emits wrong version in pkg-config
    # Remove when https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/merge_requests/13 merged & in release
    (fetchpatch {
      name = "0001-persistent-cache-cpp-CMakeLists-txt-Update-version.patch";
      url = "https://gitlab.com/OPNA2608/persistent-cache-cpp/-/commit/20d5d3f61563c62bcbe85e71ddc4fe16d7c995d5.patch";
      hash = "sha256-BKovtT9OvV+xEwBO8AZTxAzL9kqyDB9ip32t2Xx4eIk=";
    })

    # PersistentStringCacheImpl.exceptions test fails on LLVM's libcxx, it depends on std::system_error producing a very specific exception text
    # Expects "Unknown error 666", gets "unspecified generic_category error"
    # Remove when https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/merge_requests/14 merged & in release
    (fetchpatch {
      name = "0002-persistent-cache-cpp-persistent_string_cache_impl_test-libcxx-fix.patch";
      url = "https://gitlab.com/OPNA2608/persistent-cache-cpp/-/commit/a696dbd3093b8333f9ee1f0cad846b2256c729c5.patch";
      hash = "sha256-SJxdXeM7W+WKEmiLTwnQYAM7YmPayEk6vPb46y4thv4=";
    })

    # Enable usage of BUILD_TESTING to opting out of tests
    # Remove when https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/merge_requests/15 merged & in release
    (fetchpatch {
      name = "0003-persistent-cache-cpp-Enable-opting-out-of-tests.patch";
      url = "https://gitlab.com/OPNA2608/persistent-cache-cpp/-/commit/1fb06d28c16325e90046e93662c0f5fd16c29b4a.patch";
      hash = "sha256-2/6EYBh71S4dzqWEde+3dLOGp015fN6IifAj1bI1XAI=";
    })

    # Enable linking based on stdenv (static or dynamic)
    # Remove when https://gitlab.com/ubports/development/core/lib-cpp/persistent-cache-cpp/-/merge_requests/16 merged & in release
    (fetchpatch {
      name = "0004-persistent-cache-cpp-Un-hardcode-static-linking.patch";
      url = "https://gitlab.com/OPNA2608/persistent-cache-cpp/-/commit/45cd84fe76e3a0e1da41a662df695009a6f4f07e.patch";
      hash = "sha256-1UjdhzrjnIUO1ySaZTm0vkdNgok0RNlGtNOWUoAUlzU=";
    })
  ];

  postPatch = ''
    # Wrong concatenation
    substituteInPlace data/libpersistent-cache-cpp.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib"

    # Runs in parallel to other tests, limit to 1 thread
    substituteInPlace tests/headers/compile_headers.py \
      --replace 'multiprocessing.cpu_count()' '1'
  '' + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/{headers,whitespace}/*.py
  '';

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
    (lib.cmakeBool "Werror" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
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
