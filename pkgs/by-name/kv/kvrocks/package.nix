{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  ninja,
  pkg-config,
  rocksdb,
  libevent,
  fmt,
  spdlog,
  snappy,
  lz4,
  zstd,
  zlib-ng,
  onetbb,
  gtest,
  xxHash,
  jemalloc,
  openssl,
  range-v3,
  cpptrace,
  jsoncons,
  span-lite,
  hat-trie,
  pegtl,
}:

let
  luajit-src = fetchzip {
    url = "https://github.com/RocksLabs/LuaJIT/archive/c0a8e68325ec261a77bde1c8eabad398168ffe74.zip";
    hash = "sha256-Wjh14d0JR5ecAwdYVBjQYIHb2vJ1I61oR0N0LMmtq4E=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kvrocks";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "kvrocks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s4saKuezPYvcmKSqVBVDbPJcQXr6pVfIWjff7Txg8tY=";
  };

  postPatch = ''
    # Replace FetchContent-based cmake files with system library finders
    cat > cmake/rocksdb.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(ROCKSDB REQUIRED IMPORTED_TARGET rocksdb)
    add_library(rocksdb_with_headers INTERFACE)
    target_link_libraries(rocksdb_with_headers INTERFACE PkgConfig::ROCKSDB)
    EOF

    cat > cmake/libevent.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(LIBEVENT REQUIRED IMPORTED_TARGET libevent libevent_pthreads)
    add_library(event_with_headers INTERFACE)
    target_link_libraries(event_with_headers INTERFACE PkgConfig::LIBEVENT)
    if(ENABLE_OPENSSL)
      pkg_check_modules(LIBEVENT_OPENSSL REQUIRED IMPORTED_TARGET libevent_openssl)
      target_link_libraries(event_with_headers INTERFACE PkgConfig::LIBEVENT_OPENSSL)
    endif()
    EOF

    cat > cmake/fmt.cmake << 'EOF'
    include_guard()
    find_package(fmt REQUIRED)
    EOF

    cat > cmake/spdlog.cmake << 'EOF'
    include_guard()
    find_package(spdlog REQUIRED)
    EOF

    cat > cmake/snappy.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(SNAPPY REQUIRED IMPORTED_TARGET snappy)
    add_library(snappy ALIAS PkgConfig::SNAPPY)
    EOF

    cat > cmake/lz4.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(LZ4 REQUIRED IMPORTED_TARGET liblz4)
    add_library(lz4 ALIAS PkgConfig::LZ4)
    EOF

    cat > cmake/zstd.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(ZSTD REQUIRED IMPORTED_TARGET libzstd)
    add_library(zstd ALIAS PkgConfig::ZSTD)
    EOF

    cat > cmake/zlib.cmake << 'EOF'
    include_guard()
    find_package(ZLIB REQUIRED)
    add_library(zlib_with_headers INTERFACE)
    target_link_libraries(zlib_with_headers INTERFACE ZLIB::ZLIB)
    EOF

    cat > cmake/tbb.cmake << 'EOF'
    include_guard()
    find_package(TBB REQUIRED)
    add_library(tbb ALIAS TBB::tbb)
    EOF

    cat > cmake/gtest.cmake << 'EOF'
    include_guard()
    find_package(GTest REQUIRED)
    # Create aliases that kvrocks expects, linking gtest properly
    add_library(gtest_main INTERFACE)
    target_link_libraries(gtest_main INTERFACE GTest::gtest_main GTest::gtest)
    add_library(gmock INTERFACE)
    target_link_libraries(gmock INTERFACE GTest::gmock GTest::gtest)
    EOF

    cat > cmake/xxhash.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(XXHASH REQUIRED IMPORTED_TARGET libxxhash)
    add_library(xxhash ALIAS PkgConfig::XXHASH)
    EOF

    cat > cmake/jemalloc.cmake << 'EOF'
    include_guard()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(JEMALLOC REQUIRED IMPORTED_TARGET jemalloc)
    add_library(jemalloc INTERFACE)
    target_link_libraries(jemalloc INTERFACE PkgConfig::JEMALLOC)
    target_compile_definitions(jemalloc INTERFACE ENABLE_JEMALLOC)
    EOF

    cat > cmake/jsoncons.cmake << 'EOF'
    include_guard()
    add_library(jsoncons INTERFACE)
    EOF

    cat > cmake/span.cmake << 'EOF'
    include_guard()
    add_library(span-lite INTERFACE)
    EOF

    cat > cmake/trie.cmake << 'EOF'
    include_guard()
    add_library(tsl_hat_trie INTERFACE)
    EOF

    cat > cmake/pegtl.cmake << 'EOF'
    include_guard()
    add_library(pegtl INTERFACE)
    EOF

    cat > cmake/rangev3.cmake << 'EOF'
    include_guard()
    find_package(range-v3 REQUIRED)
    EOF

    cat > cmake/cpptrace.cmake << 'EOF'
    include_guard()
    find_package(cpptrace REQUIRED)
    EOF

    # Remove static linking flags and git requirement
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_EXE_LINKER_FLAGS "''${CMAKE_EXE_LINKER_FLAGS} -static-libgcc")' "" \
      --replace-fail 'set(CMAKE_EXE_LINKER_FLAGS "''${CMAKE_EXE_LINKER_FLAGS} -static-libstdc++")' "" \
      --replace-fail 'find_package(Git REQUIRED)' "" \
      --replace-fail 'target_include_directories(kvrocks_objs PUBLIC src src/common src/vendor' \
                     'target_include_directories(kvrocks_objs PUBLIC src src/common src/config src/vendor'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    rocksdb
    libevent
    fmt
    spdlog
    snappy
    lz4
    zstd
    zlib-ng
    onetbb
    gtest
    xxHash
    jemalloc
    openssl
    range-v3
    cpptrace
    jsoncons
    span-lite
    hat-trie
    pegtl
  ];

  preConfigure = ''
    # Copy LuaJIT to writable location for in-source build
    cp -r ${luajit-src} $TMPDIR/luajit
    chmod -R u+w $TMPDIR/luajit
    # LuaJIT defaults to gcc, which may be unavailable (e.g. Darwin stdenv).
    substituteInPlace $TMPDIR/luajit/src/Makefile \
      --replace-fail "DEFAULT_CC = gcc" "DEFAULT_CC = cc"
    cmakeFlagsArray+=("-DFETCHCONTENT_SOURCE_DIR_LUAJIT=$TMPDIR/luajit")
  '';

  cmakeFlags = [
    "-DDISABLE_JEMALLOC=OFF"
    "-DENABLE_STATIC_LIBSTDCXX=OFF"
    "-DENABLE_LUAJIT=ON"
    "-DENABLE_OPENSSL=ON"
    "-DPORTABLE=1"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 kvrocks -t $out/bin
    install -Dm755 kvrocks2redis -t $out/bin
    install -Dm644 $src/kvrocks.conf -t $out/etc
    runHook postInstall
  '';

  meta = {
    description = "Distributed key value NoSQL database that uses RocksDB as storage engine and is compatible with Redis protocol";
    homepage = "https://kvrocks.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xyenon ];
    platforms = lib.platforms.unix;
    mainProgram = "kvrocks";
  };
})
