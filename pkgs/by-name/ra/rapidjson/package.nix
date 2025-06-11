{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  gtest,
  valgrind,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidjson";
  version = "unstable-2024-04-09";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "ab1842a2dae061284c0a62dca1cc6d5e7e37e346";
    hash = "sha256-kAGVJfDHEUV2qNR1LpnWq3XKBJy4hD3Swh6LX5shJpM=";
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

  cmakeFlags = [
    (lib.cmakeBool "RAPIDJSON_BUILD_DOC" true)
    (lib.cmakeBool "RAPIDJSON_BUILD_TESTS" true)
    (lib.cmakeBool "RAPIDJSON_BUILD_EXAMPLES" true)
    # gtest 1.13+ requires C++14 or later.
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX11" false)
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX17" true)
    # Prevent -march=native
    (lib.cmakeBool "RAPIDJSON_ENABLE_INSTRUMENTATION_OPT" false)
    # Disable -Werror by using build type specific flags, which are
    # added after general CMAKE_CXX_FLAGS.
    (lib.cmakeFeature "CMAKE_CXX_FLAGS_RELEASE" "-Wno-error")
  ];

  doCheck = !(stdenv.hostPlatform.isStatic || stdenv.hostPlatform.isDarwin);

  nativeCheckInputs = [
    valgrind
  ];

  meta = {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.dotlambda
      lib.maintainers.Madouura
      lib.maintainers.tobim
    ];
  };
})
