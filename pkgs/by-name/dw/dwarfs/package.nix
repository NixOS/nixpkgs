{
  lib,
  fetchFromGitHub,
  stdenv,
  bison,
  boost,
  brotli,
  cmake,
  double-conversion,
  fmt,
  fuse3,
  flac,
  glog,
  gtest,
  howard-hinnant-date,
  jemalloc,
  libarchive,
  libevent,
  libunwind,
  lz4,
  openssl,
  pkg-config,
  python3,
  range-v3,
  ronn,
  xxHash,
  utf8cpp,
  zstd,
  parallel-hashmap,
  nlohmann_json,
  libdwarf,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwarfs";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "mhx";
    repo = "dwarfs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-EYNnmv0QKdWddIRFRsuwsazHep3nrJ8lInlR4S67rME=";
  };

  cmakeFlags = [
    "-DNIXPKGS_DWARFS_VERSION_OVERRIDE=v${finalAttrs.version}" # see https://github.com/mhx/dwarfs/issues/155

    # Needs to be set so `dwarfs` does not try to download `gtest`; it is not
    # a submodule, see: https://github.com/mhx/dwarfs/issues/188#issuecomment-1907657083
    "-DPREFER_SYSTEM_GTEST=ON"
    "-DWITH_LEGACY_FUSE=ON"
    "-DWITH_TESTS=ON"
  ];

  nativeBuildInputs = [
    bison
    cmake
    howard-hinnant-date # uses only the header-only parts
    pkg-config
    range-v3 # header-only library
    ronn
    (python3.withPackages (ps: [ ps.mistletoe ])) # for man pages
  ];

  buildInputs = [
    # dwarfs
    parallel-hashmap
    nlohmann_json
    boost
    brotli
    flac # optional; allows automatic audio compression
    fmt
    fuse3
    jemalloc
    libarchive
    lz4
    xxHash
    utf8cpp
    zstd

    # folly
    double-conversion
    glog
    libevent
    libunwind
    openssl
    libdwarf # DWARFS_STACKTRACE_ENABLED relies on FOLLY_USE_SYMBOLIZER, which needs FOLLY_HAVE_DWARF
  ];

  doCheck = true;
  nativeCheckInputs = [
    # https://github.com/mhx/dwarfs/issues/188#issuecomment-1907574427
    # `dwarfs` sets C++20 as the minimum, see
    #     https://github.com/mhx/dwarfs/blob/2cb5542a5d4274225c5933370adcf00035f6c974/CMakeLists.txt#L129
    # Thus the `gtest` headers, when included,
    # refer to symbols that only exist in `.so` files compiled with that version.
    (gtest.override { cxx_standard = "20"; })
  ];
  # these fail inside of the sandbox due to missing access
  # to the FUSE device
  GTEST_FILTER =
    let
      disabledTests = [
        "dwarfs/tools_test.end_to_end/*"
        "dwarfs/tools_test.mutating_and_error_ops/*"
        "dwarfs/tools_test.categorize/*"
      ];
    in
    "-${lib.concatStringsSep ":" disabledTests}";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckProgram = "${placeholder "out"}/bin/dwarfs";

  meta = {
    description = "Fast high compression read-only file system";
    homepage = "https://github.com/mhx/dwarfs";
    changelog = "https://github.com/mhx/dwarfs/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    platforms = lib.platforms.linux;
  };
})
