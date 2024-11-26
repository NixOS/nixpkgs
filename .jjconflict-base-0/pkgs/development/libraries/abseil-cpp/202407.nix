{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gtest
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abseil-cpp";
  version = "20240722.0";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-51jpDhdZ0n+KLmxh8KVaTz53pZAB0dHjmILFX+OLud4=";
  };

  patches = [
    # Don't match -Wnon-virtual-dtor in the "flags are needed to suppress
    # Needed to cleanly apply the #1738 fix below.
    # https://github.com/abseil/abseil-cpp/issues/1737
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/9cb5e5d15c142e5cc43a2c1db87c8e4e5b6d38a5.patch";
      hash = "sha256-PTNmNJMk42Omwek0ackl4PjxifDP/+GaUitS60l+VB0=";
    })

    # Fix shell option group handling in pkgconfig files
    # https://github.com/abseil/abseil-cpp/pull/1738
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/bd0c9c58cac4463d96b574de3097422bb78215a8.patch";
      hash = "sha256-fB9pvkyNBXoDKLrVaNwliqrWEPTa2Y6OJMe2xgl5IBc=";
    })
  ];

  cmakeFlags = [
    "-DABSL_BUILD_TEST_HELPERS=ON"
    "-DABSL_USE_EXTERNAL_GOOGLETEST=ON"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ] ++ lib.optionals (cxxStandard != null) [
    "-DCMAKE_CXX_STANDARD=${cxxStandard}"
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  meta = {
    description = "Open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.GaetanLepage ];
  };
})
