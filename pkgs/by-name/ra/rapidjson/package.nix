{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  gtest,
  unstableGitUpdater,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidjson";
  version = "1.1.0-unstable-2026-11-03";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "297637bc0a0f00dc504dbc1a47ebdaa577f8ae19";
    hash = "sha256-VW7nkgByMJseWWPsSklzdtUiX0tPVWfLj1Tr3x11TT4=";
  };

  patches = [
    ./use-nixpkgs-gtest.patch
    # https://github.com/Tencent/rapidjson/issues/2214
    ./suppress-valgrind-failures.patch

    # disable tests which don't build on clang-19
    # https://github.com/Tencent/rapidjson/issues/2318
    ./char_traits-clang-19-errors.diff
  ];

  postPatch = ''
    for f in doc/Doxyfile.*; do
      substituteInPlace $f \
        --replace-fail "WARN_IF_UNDOCUMENTED   = YES" "WARN_IF_UNDOCUMENTED   = NO"
    done
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  buildInputs = [
    gtest
  ];

  strictDeps = true;

  env = lib.optionalAttrs stdenv.hostPlatform.isi686 {
    CFLAGS = "-mfpmath=sse -msse2";
    CXXFLAGS = "-mfpmath=sse -msse2";
  };

  cmakeFlags = [
    (lib.cmakeBool "RAPIDJSON_BUILD_DOC" true)
    (lib.cmakeBool "RAPIDJSON_BUILD_TESTS" true)
    (lib.cmakeBool "RAPIDJSON_BUILD_EXAMPLES" false)
    # gtest 1.13+ requires C++14 or later.
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX11" false)
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX17" true)
    # Prevent -march=native
    (lib.cmakeBool "RAPIDJSON_ENABLE_INSTRUMENTATION_OPT" false)
    # Disable -Werror by using build type specific flags, which are
    # added after general CMAKE_CXX_FLAGS.
    (lib.cmakeFeature "CMAKE_CXX_FLAGS_RELEASE" "-Wno-error")
  ];

  doCheck =
    !(stdenv.hostPlatform.isStatic || stdenv.hostPlatform.isDarwin)
    && lib.meta.availableOn stdenv.hostPlatform valgrind;

  nativeCheckInputs = [
    valgrind
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
    };
  };

  meta = {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.dotlambda
      lib.maintainers.tobim
    ];
  };
})
