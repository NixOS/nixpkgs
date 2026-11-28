{
  lib,
  stdenv,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libserial";
  version = "1.0.0-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "crayzeewulf";
    repo = "libserial";
    # The v1.0.0 tag (most recent tag) lacks the <cstdint> fix and the CMake options
    # for docs, tests, and Python bindings. Pin a later commit.
    rev = "50e0f443666d48d7c7e181dc73a6b35700517fae";
    hash = "sha256-i4Ty3X5uj1m3EzDbgS5tt+JiDGvoJf0TCf3pC5oyS0s=";
  };

  patches = [
    # Fix libserial.pc paths when GNUInstallDirs values are absolute (as in
    # Nixpkgs) and install the generated Doxygen HTML. Drop once merged
    # upstream and pinned.
    # https://github.com/crayzeewulf/libserial/pull/204
    (fetchpatch {
      url = "https://github.com/crayzeewulf/libserial/commit/82ab2e86b97d89f3360f4398420806edef02722f.patch";
      hash = "sha256-OOxcF4+79LzcFC52AVGG1qm+oopLWiOtIUf1IusMVFc=";
    })
  ];

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  cmakeFlags = [
    # Upstream tests open hardcoded serial devices (/dev/ttyUSB0, /dev/ttyUSB1)
    # that don't exist in the build sandbox. Basic functionality is covered by
    # passthru.tests.roundtrip instead.
    (lib.cmakeBool "LIBSERIAL_ENABLE_TESTING" false)
    (lib.cmakeBool "LIBSERIAL_PYTHON_ENABLE" false)
    (lib.cmakeBool "LIBSERIAL_BUILD_EXAMPLES" false)
  ];

  passthru.tests.roundtrip = stdenv.mkDerivation {
    name = "libserial-roundtrip-test";
    dontUnpack = true;

    nativeBuildInputs = [ pkg-config ];

    # Keep libserial out of buildInputs so compiler and linker search paths
    # come from libserial.pc rather than the stdenv setup hooks. This makes
    # the test also verify that the .pc file has correct paths.
    PKG_CONFIG_PATH = "${finalAttrs.finalPackage}/lib/pkgconfig";

    buildPhase = ''
      runHook preBuild

      $CXX -std=c++17 ${./test-roundtrip.cpp} -o roundtrip \
        $(pkg-config --cflags --libs libserial) \
        -Wl,-rpath,"$(pkg-config --variable=libdir libserial)"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      ./roundtrip
      touch $out

      runHook postInstall
    '';
  };

  meta = {
    description = "Serial port programming in C++";
    homepage = "https://github.com/crayzeewulf/libserial";
    changelog = "https://github.com/crayzeewulf/libserial/compare/v1.0.0...${finalAttrs.src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bugsaplenty
    ];
    platforms = lib.platforms.linux;
  };
})
