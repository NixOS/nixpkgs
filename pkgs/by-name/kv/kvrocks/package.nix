{
  callPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,

  # keep-sorted start
  cmake,
  ninja,
  pkg-config,
  # keep-sorted end

  # keep-sorted start
  cpptrace,
  fmt,
  gtest,
  hat-trie,
  jemalloc,
  jsoncons,
  libevent,
  lz4,
  onetbb,
  openssl,
  pegtl,
  range-v3,
  rocksdb,
  snappy,
  span-lite,
  spdlog,
  xxHash,
  zlib-ng,
  zstd,
  # keep-sorted end
}:

let
  # Generate a cmake file that replaces FetchContent with system library finders.
  #   findPackage: optional package name for find_package(name REQUIRED)
  #   pkgConfig:   optional { varName; modules; } for pkg_check_modules
  #   libraries:   list of { name; target?; linkLibs?; compileDefs?; }
  #                  - if 'target' is set: add_library(name ALIAS target)
  #                  - otherwise: add_library(name INTERFACE) with optional link/defs
  #   extraLines:  optional list of extra cmake lines appended at the end
  mkCmakeFile =
    cmakeFile:
    {
      findPackage ? null,
      pkgConfig ? null,
      libraries ? [ ],
      extraLines ? [ ],
    }:
    let
      mkLibEntry =
        entry:
        if entry ? target then
          [ "add_library(${entry.name} ALIAS ${entry.target})" ]
        else
          [ "add_library(${entry.name} INTERFACE)" ]
          ++ lib.optional (
            entry ? linkLibs
          ) "target_link_libraries(${entry.name} INTERFACE ${entry.linkLibs})"
          ++ lib.optional (
            entry ? compileDefs
          ) "target_compile_definitions(${entry.name} INTERFACE ${entry.compileDefs})";
      lines = [
        "include_guard()"
      ]
      ++ lib.optional (pkgConfig != null) "find_package(PkgConfig REQUIRED)"
      ++ lib.optional (findPackage != null) "find_package(${findPackage} REQUIRED)"
      ++ lib.optional (
        pkgConfig != null
      ) "pkg_check_modules(${pkgConfig.varName} REQUIRED IMPORTED_TARGET ${pkgConfig.modules})"
      ++ lib.concatMap mkLibEntry libraries
      ++ extraLines;
      content = lib.concatStringsSep "\n" lines;
    in
    ''
      cat > cmake/${cmakeFile}.cmake << 'EOF'
      ${content}
      EOF
    '';

  luajit-src = fetchFromGitHub {
    owner = "RocksLabs";
    repo = "LuaJIT";
    rev = "c0a8e68325ec261a77bde1c8eabad398168ffe74";
    hash = "sha256-Wjh14d0JR5ecAwdYVBjQYIHb2vJ1I61oR0N0LMmtq4E=";
  };

  zlib-ng' = zlib-ng.override { withZlibCompat = true; };
  rocksdb' =
    (rocksdb.override {
      zlib = zlib-ng';
      enableJemalloc = true;
    }).overrideAttrs
      (oldAttrs: {
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [ (lib.cmakeBool "WITH_TBB" true) ];
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ onetbb ];
        # On aarch64-darwin, libc++ hardening can trigger a SIGTRAP in
        # RocksDB's startup path via unique_ptr<T[]> bounds checks.
        hardeningDisable =
          (oldAttrs.hardeningDisable or [ ])
          ++ (lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
            "libcxxhardeningfast"
          ]);
      });
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

  __structuredAttrs = true;

  postPatch = ''
    # Replace FetchContent-based cmake files with system library finders
    ${mkCmakeFile "rocksdb" {
      pkgConfig = {
        varName = "ROCKSDB";
        modules = "rocksdb";
      };
      libraries = [
        {
          name = "rocksdb_with_headers";
          linkLibs = "PkgConfig::ROCKSDB";
        }
      ];
    }}
    ${mkCmakeFile "libevent" {
      pkgConfig = {
        varName = "LIBEVENT";
        modules = "libevent libevent_pthreads";
      };
      libraries = [
        {
          name = "event_with_headers";
          linkLibs = "PkgConfig::LIBEVENT";
        }
      ];
      extraLines = [
        "if(ENABLE_OPENSSL)"
        "  pkg_check_modules(LIBEVENT_OPENSSL REQUIRED IMPORTED_TARGET libevent_openssl)"
        "  target_link_libraries(event_with_headers INTERFACE PkgConfig::LIBEVENT_OPENSSL)"
        "endif()"
      ];
    }}
    ${mkCmakeFile "fmt" { findPackage = "fmt"; }}
    ${mkCmakeFile "spdlog" { findPackage = "spdlog"; }}
    ${mkCmakeFile "snappy" {
      pkgConfig = {
        varName = "SNAPPY";
        modules = "snappy";
      };
      libraries = [
        {
          name = "snappy";
          target = "PkgConfig::SNAPPY";
        }
      ];
    }}
    ${mkCmakeFile "lz4" {
      pkgConfig = {
        varName = "LZ4";
        modules = "liblz4";
      };
      libraries = [
        {
          name = "lz4";
          target = "PkgConfig::LZ4";
        }
      ];
    }}
    ${mkCmakeFile "zstd" {
      pkgConfig = {
        varName = "ZSTD";
        modules = "libzstd";
      };
      libraries = [
        {
          name = "zstd";
          target = "PkgConfig::ZSTD";
        }
      ];
    }}
    ${mkCmakeFile "zlib" {
      findPackage = "ZLIB";
      libraries = [
        {
          name = "zlib_with_headers";
          linkLibs = "ZLIB::ZLIB";
        }
      ];
    }}
    ${mkCmakeFile "tbb" {
      findPackage = "TBB";
      libraries = [
        {
          name = "tbb";
          target = "TBB::tbb";
        }
      ];
    }}
    ${mkCmakeFile "gtest" {
      findPackage = "GTest";
      libraries = [
        {
          name = "gtest_main";
          linkLibs = "GTest::gtest_main GTest::gtest";
        }
        {
          name = "gmock";
          linkLibs = "GTest::gmock GTest::gtest";
        }
      ];
    }}
    ${mkCmakeFile "xxhash" {
      pkgConfig = {
        varName = "XXHASH";
        modules = "libxxhash";
      };
      libraries = [
        {
          name = "xxhash";
          target = "PkgConfig::XXHASH";
        }
      ];
    }}
    ${mkCmakeFile "jemalloc" {
      pkgConfig = {
        varName = "JEMALLOC";
        modules = "jemalloc";
      };
      libraries = [
        {
          name = "jemalloc";
          linkLibs = "PkgConfig::JEMALLOC";
          compileDefs = "ENABLE_JEMALLOC";
        }
      ];
    }}
    ${mkCmakeFile "jsoncons" { libraries = [ { name = "jsoncons"; } ]; }}
    ${mkCmakeFile "span" { libraries = [ { name = "span-lite"; } ]; }}
    ${mkCmakeFile "trie" { libraries = [ { name = "tsl_hat_trie"; } ]; }}
    ${mkCmakeFile "pegtl" { libraries = [ { name = "pegtl"; } ]; }}
    ${mkCmakeFile "rangev3" { findPackage = "range-v3"; }}
    ${mkCmakeFile "cpptrace" { findPackage = "cpptrace"; }}

    # Remove static linking flags and git requirement
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(CMAKE_EXE_LINKER_FLAGS "''${CMAKE_EXE_LINKER_FLAGS} -static-libgcc")' "" \
      --replace-fail 'set(CMAKE_EXE_LINKER_FLAGS "''${CMAKE_EXE_LINKER_FLAGS} -static-libstdc++")' "" \
      --replace-fail 'find_package(Git REQUIRED)' "" \
      --replace-fail 'target_include_directories(kvrocks_objs PUBLIC src src/common src/vendor' \
                     'target_include_directories(kvrocks_objs PUBLIC src src/common src/config src/vendor'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    # keep-sorted start
    cmake
    ninja
    pkg-config
    # keep-sorted end
  ];

  buildInputs = [
    # keep-sorted start
    cpptrace
    fmt
    gtest
    hat-trie
    jemalloc
    jsoncons
    libevent
    lz4
    onetbb
    openssl
    pegtl
    range-v3
    rocksdb'
    snappy
    span-lite
    spdlog
    xxHash
    zlib-ng'
    zstd
    # keep-sorted end
  ];

  preConfigure = ''
    # Copy LuaJIT to writable location for in-source build
    cp -r ${luajit-src} $TMPDIR/luajit
    chmod -R u+w $TMPDIR/luajit
    # LuaJIT defaults to gcc, which may be unavailable (e.g. Darwin stdenv).
    substituteInPlace $TMPDIR/luajit/src/Makefile \
      --replace-fail "DEFAULT_CC = gcc" "DEFAULT_CC = $CC"
    cmakeFlagsArray+=("-DFETCHCONTENT_SOURCE_DIR_LUAJIT=$TMPDIR/luajit")
  '';

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_JEMALLOC" false)
    (lib.cmakeBool "ENABLE_STATIC_LIBSTDCXX" false)
    (lib.cmakeBool "ENABLE_LUAJIT" true)
    (lib.cmakeBool "ENABLE_OPENSSL" true)
    (lib.cmakeFeature "PORTABLE" "1")
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 kvrocks -t $out/bin
    install -Dm755 kvrocks2redis -t $out/bin
    install -Dm644 $src/kvrocks.conf -t $out/etc
    runHook postInstall
  '';

  passthru = {
    hook = callPackage ./hook.nix { kvrocks = finalAttrs.finalPackage; };
    tests = {
      inherit (nixosTests) kvrocks;
      hook = callPackage ./hook-test.nix { kvrocks = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Distributed key value NoSQL database that uses RocksDB as storage engine and is compatible with Redis protocol";
    homepage = "https://kvrocks.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ xyenon ];
    platforms = lib.platforms.unix;
    mainProgram = "kvrocks";
  };
})
