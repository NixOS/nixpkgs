{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  hwloc,
  ninja,
  pkg-config,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "onetbb";
  version = "2022.3.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HIHF6KHlEI4rgQ9Epe0+DmNe1y95K9iYa4V/wFnJfEU=";
  };

  patches = [
    # <https://github.com/uxlfoundation/oneTBB/pull/899>
    ./fix-musl-build.patch

    # <https://github.com/uxlfoundation/oneTBB/pull/987>
    ./fix-32-bit-powerpc-build.patch

    # Fix an assumption that `libtbbmalloc` can pass a relative path to
    # `dlopen(3)` to find itself. This caused mysterious crashes on
    # macOS, where we do not use run paths by default.
    #
    # <https://github.com/uxlfoundation/oneTBB/pull/1849>
    ./fix-libtbbmalloc-dlopen.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    ctestCheckHook
    pkg-config
  ];

  buildInputs = [
    hwloc
  ];

  doCheck = true;

  dontUseNinjaCheck = true;

  # The memory leak test fails on static Linux, despite passing on
  # dynamic Musl.
  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) [
    "test_arena_constraints"
  ];

  # Disable failing test on musl
  # test/conformance/conformance_resumable_tasks.cpp:37:24: error: ‘suspend’ is not a member of ‘tbb::v1::task’; did you mean ‘tbb::detail::r1::suspend’?
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail 'tbb_add_test(SUBDIR conformance NAME conformance_resumable_tasks DEPENDENCIES TBB::tbb)' ""
  '';

  cmakeFlags = [
    (lib.cmakeBool "TBB_DISABLE_HWLOC_AUTOMATIC_SEARCH" false)
  ];

  env = {
    # Fix build with modern gcc
    # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=stringop-overflow";

    # Fix undefined reference errors with version script under LLVM.
    NIX_LDFLAGS = lib.optionalString (
      stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
    ) "--undefined-version";

    # Some test fail because hwloc tries to read /sys on non-x86, which doesn't
    # work in the build sandbox, so provide fake data to satisfy it
    # See: https://www-lb.open-mpi.org/projects/hwloc/doc/v2.12.2/synthetic.html
    HWLOC_SYNTHETIC = "node:1 core:1 pu:1";
  };

  meta = {
    description = "oneAPI Threading Building Blocks";
    homepage = "https://uxlfoundation.github.io/oneTBB/";
    license = lib.licenses.asl20;
    longDescription = ''
      oneAPI Threading Building Blocks (oneTBB) is a runtime-based
      parallel programming model for C++ code that uses tasks. The
      template-based runtime library can help you harness the latent
      performance of multi-core processors.
    '';
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      silvanshade
      thoughtpolice
      tmarkus
    ];
  };
})
