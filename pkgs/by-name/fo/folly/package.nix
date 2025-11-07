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
  darwinMinVersionHook,

  boost,
  fmt,

  ctestCheckHook,

  gtest,

  follyMobile ? false,

  nix-update-script,

  # for passthru.tests
  python3,
  watchman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "folly";
  version = "2025.09.15.00";

  # split outputs to reduce downstream closure sizes
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//gx081nMFXAcUgkHQToiFHhECfLW22Fl0eXEsObxUs=";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (darwinMinVersionHook "13.3")
  ];

  propagatedBuildInputs = [
    # `folly-config.cmake` pulls these in.
    boost
    fmt
  ];

  nativeCheckInputs = [
    ctestCheckHook
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

  dontUseNinjaCheck = true;

  patches = [
    # Install the certificate files used by `libfolly_test_util` rather
    # than leaving a dangling reference to the build directory in the
    # `dev` output’s CMake files.
    ./install-test-certs.patch

    # The base template for std::char_traits has been removed in LLVM 19
    # https://releases.llvm.org/19.1.0/projects/libcxx/docs/ReleaseNotes.html
    ./char_traits.patch

    # <https://github.com/facebook/folly/issues/2171>
    (fetchpatch {
      name = "folly-fix-glog-0.7.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix-cmake-find-glog.patch?h=folly&id=4b68f47338d4b20111e3ffa1291433120bb899f0";
      hash = "sha256-QGNpS5UNEm+0PW9+agwUVILzpK9t020KXDGyP03OAwE=";
    })

    # Fix an upstream regression with libstdc++.
    #
    # See:
    #
    # * <https://github.com/facebook/folly/issues/2487>
    # * <https://github.com/facebook/folly/commit/bdbb73e0069b4084c83b7dd9b02c3118d37e2a8d>
    # * <https://github.com/facebook/folly/pull/2490>
    # * <https://github.com/facebook/folly/pull/2497>
    ./fix-stdexcept-include.patch

    # Fix a GCC‐incompatible use of a private trait.
    #
    # Per Folly’s own documentation:
    #
    #     /// Under gcc, the builtin is available but does not mangle. Therefore, this
    #     /// trait must not be used anywhere it might be subject to mangling, such as in
    #     /// a return-type expression.
    #
    # See:
    #
    # * <https://github.com/facebook/folly/issues/2493>
    # * <https://github.com/facebook/folly/pull/2499>
    ./fix-__type_pack_element.patch
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

  disabledTests = [
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

    # In file included from /build/source/folly/lang/test/BitsTest.cpp:17:
    # In member function 'constexpr bool folly::get_bit_at_fn::operator()(const Uint*, std::size_t) const [with Uint = short unsigned int]',
    #     inlined from 'void folly::BitsAllUintsTest_GetBitAtLE_Test<gtest_TypeParam_>::TestBody() [with gtest_TypeParam_ = short unsigned int]' at /build/source/folly/lang/test/BitsTest.cpp:640:5:
    # /build/source/folly/lang/Bits.h:494:10: warning: 'in' is used uninitialized [-Wuninitialized]
    "lang_bits_test.BitsAllUintsTest/*.GetBitAtLE"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "concurrency_cache_locality_test.CacheLocality.BenchmarkSysfs"
    "concurrency_cache_locality_test.CacheLocality.LinuxActual"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # No idea why these fail.
    "logging_xlog_test.XlogTest.perFileCategoryHandling"
    "futures_future_test.Future.makeFutureFromMoveOnlyException"
  ];

  passthru = {
    inherit boost fmt;

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
