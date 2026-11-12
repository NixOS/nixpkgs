{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ragel,
  python3,
  util-linux,
  pkg-config,
  boost,
  openssl,
  pcre,
  withStatic ? false, # build only shared libs by default, build static+shared if true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyperscan";
  version = "5.4.2.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "hyperscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6wfekQ4ySN+ejh8cGdFwZb2tOTYZxoZye3ROMsV4oYg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    sed -i '/examples/d' CMakeLists.txt
    substituteInPlace libhs.pc.in \
      --replace-fail "libdir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@" "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace-fail "includedir=@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_INCLUDEDIR@" "includedir=@CMAKE_INSTALL_INCLUDEDIR@"

    substituteInPlace cmake/pcre.cmake --replace-fail 'CHECK_C_SOURCE_COMPILES("#include <pcre.h.generic>
        #if PCRE_MAJOR != ''${PCRE_REQUIRED_MAJOR_VERSION} || PCRE_MINOR < ''${PCRE_REQUIRED_MINOR_VERSION}
        #error Incorrect pcre version
        #endif
        main() {}" CORRECT_PCRE_VERSION)' 'set(CORRECT_PCRE_VERSION TRUE)'
  ''
  # CMake 4 dropped support of versions lower than 3.5,
  # versions lower than 3.10 are deprecated.
  # https://github.com/NixOS/nixpkgs/issues/445447
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "cmake_minimum_required (VERSION 2.8.11)" \
        "cmake_minimum_required (VERSION 3.10)"
  ''
  # FAT_RUNTIME prefixes every global symbol not listed in keep.syms. Upstream
  # adds libcrypto's symbols via `cc --print-file-name`, which cannot find the
  # library in the Nix sandbox, so OpenSSL references get prefixed and fail to link.
  + ''
    substituteInPlace cmake/build_wrapper.sh \
      --replace-fail \
        'LIBCRYPTO_SO=$("$@" --print-file-name=libcrypto.so)' \
        'LIBCRYPTO_SO=${lib.getLib openssl}/lib/libcrypto${stdenv.hostPlatform.extensions.sharedLibrary}'
  ''
  # unit-hyperscan calls these internal helpers, but shared builds use
  # -fvisibility=hidden, so the test fails to link against libhs.so.
  + ''
    substituteInPlace src/database.h \
      --replace-fail \
        "void hs_db_free(void *ptr, size_t size);" \
        "HS_PUBLIC_API void hs_db_free(void *ptr, size_t size);" \
      --replace-fail \
        "void hs_db_unprotect(void *ptr, size_t size);" \
        "HS_PUBLIC_API void hs_db_unprotect(void *ptr, size_t size);"
  ''
  # hscollider (an uninstalled test tool, built only when pcre sources are
  # present) includes util/hash_util.h, which upstream never committed.
  + ''
    rm tools/hscollider/CMakeLists.txt
  '';

  buildInputs = [
    boost
    openssl
  ];
  nativeBuildInputs = [
    cmake
    ragel
    python3
    util-linux
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_AVX512" true)
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (lib.cmakeBool "FAT_RUNTIME" true)
  ]
  ++ lib.optionals withStatic [
    (lib.cmakeBool "BUILD_STATIC_AND_SHARED" true)
  ]
  ++ lib.optionals (!withStatic) [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  # hyperscan CMake is completely broken for chimera builds when pcre is compiled
  # the only option to make it build - building from source
  # In case pcre is built from source, chimera build is turned on by default
  preConfigure = lib.optionalString withStatic (
    ''
      mkdir -p pcre
      tar xvf ${pcre.src} --strip-components 1 -C pcre
    ''
    # - CMake 4 dropped support of versions lower than 3.5, versions lower than 3.10 are deprecated.
    #   https://github.com/NixOS/nixpkgs/issues/445447
    # - CMake Error at pcre/CMakeLists.txt:843 (GET_TARGET_PROPERTY):
    #   The LOCATION property may not be read from target "pcretest".  Use the
    #   target name directly with add_custom_command, or use the generator
    #   expression $<TARGET_FILE>, as appropriate.
    + ''
      substituteInPlace pcre/CMakeLists.txt \
        --replace-fail \
          "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.5)" \
          "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)" \
        --replace-fail \
          "CMAKE_POLICY(SET CMP0026 OLD)" \
          "CMAKE_POLICY(SET CMP0026 NEW)" \
        --replace-fail \
          "GET_TARGET_PROPERTY(PCRETEST_EXE pcretest DEBUG_LOCATION)" \
          "set(PCRETEST_EXE $<TARGET_FILE:pcretest>)"
    ''
  );

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    bin/unit-hyperscan
    ${lib.optionalString withStatic "bin/unit-chimera"}

    runHook postCheck
  '';

  meta = {
    description = "High-performance multiple regex matching library";
    longDescription = ''
      Hyperscan is a high-performance multiple regex matching library.
      It follows the regular expression syntax of the commonly-used
      libpcre library, but is a standalone library with its own C API.

      Hyperscan uses hybrid automata techniques to allow simultaneous
      matching of large numbers (up to tens of thousands) of regular
      expressions and for the matching of regular expressions across
      streams of data.

      Hyperscan is typically used in a DPI library stack.
    '';

    homepage = "https://www.hyperscan.io/";
    maintainers = with lib.maintainers; [ avnik ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    license = lib.licenses.bsd3;
  };
})
