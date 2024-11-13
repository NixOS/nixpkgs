{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
  removeReferencesTo,

  boost,
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
  fmt_8,
  jemalloc,
  apple-sdk_11,
  darwinMinVersionHook,

  follyMobile ? false,

  # for passthru.tests
  python3,
  watchman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "folly";
  version = "2024.11.18.00";

  # split outputs to reduce downstream closure sizes
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-CX4YzNs64yeq/nDDaYfD5y8GKrxBueW4y275edPoS0c=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    removeReferencesTo
  ];

  # See CMake/folly-deps.cmake in the Folly source tree.
  buildInputs =
    [
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
      fmt_8
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux jemalloc
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  # jemalloc headers are required in include/folly/portability/Malloc.h
  propagatedBuildInputs = lib.optional stdenv.hostPlatform.isLinux jemalloc;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"

    # temporary hack until folly builds work on aarch64,
    # see https://github.com/facebook/folly/issues/1880
    "-DCMAKE_LIBRARY_ARCHITECTURE=${if stdenv.hostPlatform.isx86_64 then "x86_64" else "dummy"}"

    # Folly uses these instead of the standard CMake variables for some reason.
    (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "dev"}/include")
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "dev"}/lib/cmake/folly")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "dev"))
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-DFOLLY_MOBILE=${if follyMobile then "1" else "0"}"
    "-fpermissive"
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

  postFixup = ''
    # Sanitize header paths to avoid runtime dependencies leaking in
    # through `__FILE__`.
    (
      shopt -s globstar
      for header in "$dev/include"/**/*.h; do
        sed -i "1i#line 1 \"$header\"" "$header"
        remove-references-to -t "$dev" "$header"
      done
    )
  '';

  passthru = {
    # folly-config.cmake, will `find_package` these, thus there should be
    # a way to ensure abi compatibility.
    inherit boost;
    fmt = fmt_8;

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
      abbradar
      pierreis
    ];
  };
})
