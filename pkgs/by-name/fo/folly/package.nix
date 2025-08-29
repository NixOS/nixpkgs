{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,
  pkg-config,

  double-conversion,
  fast-float,
  gflags,
  glog,
  libevent,
  zlib,
  openssl,
  xz,
  lz4,
  zstd,
  libiberty,
  libunwind,

  boost,
  fmt_11,
  jemalloc,

  gtest,

  follyMobile ? false,

  nix-update-script,

  # for passthru.tests
  python3,
  watchman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "folly";
  version = "2025.04.21.00";

  # split outputs to reduce downstream closure sizes
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P2saSFVRBWt5xjAWlKmcPJT9MFV9CXFmA18dIDCO84o=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  # See CMake/folly-deps.cmake in the Folly source tree.
  buildInputs = [
    boost
    double-conversion
    fast-float
    gflags
    glog
    libevent
    zlib
    openssl
    xz
    lz4
    zstd
    libiberty
    libunwind
  ];

  propagatedBuildInputs = [
    # `folly-config.cmake` pulls these in.
    boost
    fmt_11
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # jemalloc headers are required in include/folly/portability/Malloc.h
    jemalloc
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)

    # Folly uses these instead of the standard CMake variables for some reason.
    (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "dev"}/include")
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "dev"}/lib/cmake/folly")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "dev"))
  ];

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " (
    [
      "-DFOLLY_MOBILE=${if follyMobile then "1" else "0"}"
    ]
    ++ lib.optionals (stdenv.cc.isGNU && stdenv.hostPlatform.isAarch64) [
      # /build/source/folly/algorithm/simd/Movemask.h:156:32: error: cannot convert '__Uint64x1_t' to '__Uint8x8_t'
      "-flax-vector-conversions"
    ]
  );

  # https://github.com/facebook/folly/blob/main/folly/DiscriminatedPtr.h
  # error: #error "DiscriminatedPtr is x64, arm64, ppc64 and riscv64 specific code."
  doCheck =
    stdenv.hostPlatform.isx86_64
    || stdenv.hostPlatform.isAarch64
    || stdenv.hostPlatform.isPower64
    || stdenv.hostPlatform.isRiscV64;

  patches = [
    # The base template for std::char_traits has been removed in LLVM 19
    # https://releases.llvm.org/19.1.0/projects/libcxx/docs/ReleaseNotes.html
    ./char_traits.patch

    # <https://github.com/facebook/folly/issues/2171>
    (fetchpatch {
      name = "folly-fix-glog-0.7.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-cmake-find-glog.patch?h=folly&id=4b68f47338d4b20111e3ffa1291433120bb899f0";
      hash = "sha256-QGNpS5UNEm+0PW9+agwUVILzpK9t020KXDGyP03OAwE=";
    })
  ];

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace CMake/libfolly.pc.in \
      --replace-fail \
        ${lib.escapeShellArg "\${exec_prefix}/@LIB_INSTALL_DIR@"} \
        '@CMAKE_INSTALL_FULL_LIBDIR@' \
      --replace-fail \
        ${lib.escapeShellArg "\${prefix}/@CMAKE_INSTALL_INCLUDEDIR@"} \
        '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  # TODO: Figure out why `GTEST_FILTER` doesn’t work to skip these.
  checkPhase = ''
    runHook preCheck

    ctest -j $NIX_BUILD_CORES --output-on-failure --exclude-regex ${
      lib.escapeShellArg (
        lib.concatMapStringsSep "|" (test: "^${lib.escapeRegex test}$") (
          [
            "concurrency_concurrent_hash_map_test.*/ConcurrentHashMapTest/*.StressTestReclamation"
            "io_async_ssl_session_test.SSLSessionTest.BasicTest"
            "io_async_ssl_session_test.SSLSessionTest.NullSessionResumptionTest"
            "singleton_thread_local_test.SingletonThreadLocalDeathTest.Overload"

            # very strict timing constraints, will fail under load
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.CancelTimeout"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.DefaultTimeout"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.DeleteWheelInTimeout"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.DestroyTimeoutSet"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.FireOnce"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.GetTimeRemaining"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.IntrusivePtr"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.Level1"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.NegativeTimeout"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.ReschedTest"
            "io_async_hh_wheel_timer_test.HHWheelTimerTest.SlowFast"
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            "concurrency_cache_locality_test.CacheLocality.BenchmarkSysfs"
            "concurrency_cache_locality_test.CacheLocality.LinuxActual"
            "futures_future_test.Future.NoThrow"
            "futures_retrying_test.RetryingTest.largeRetries"
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            "buffered_atomic_test.BufferedAtomic.singleThreadUnguardedAccess"
            "io_async_notification_queue_test.NotificationQueueTest.UseAfterFork"
            "container_heap_vector_types_test.HeapVectorTypes.SimpleSetTes"
          ]
        )
      )
    }

    runHook postCheck
  '';

  passthru = {
    inherit boost;
    fmt = fmt_11;

    updateScript = nix-update-script { };

    tests = {
      inherit watchman;
      inherit (python3.pkgs) django pywatchman;
    };
  };

  meta = {
    description = "Open-source C++ library developed and used at Facebook";
    homepage = "https://github.com/facebook/folly";
    license = lib.licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = lib.platforms.unix;
    badPlatforms = [ lib.systems.inspect.patterns.is32bit ];
    maintainers = with lib.maintainers; [
      pierreis
      emily
      techknowlogick
    ];
  };
})
