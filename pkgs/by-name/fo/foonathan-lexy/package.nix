{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "foonathan-lexy";
  version = "2025.05.0";

  src = fetchFromGitHub {
    owner = "foonathan";
    repo = "lexy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ONoMGos5Xo2JqvXwLmq6B7XH1eG25FVkSbgYKvr5QpI=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ] ++ lib.optionals finalAttrs.finalPackage.doCheck [ doctest ];

  cmakeFlags = [
    "-DLEXY_BUILD_EXAMPLES=OFF"
    (lib.cmakeBool "LEXY_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ lib.optionals finalAttrs.finalPackage.doCheck [
    "-Ddoctest_DIR=${doctest}/lib/cmake/doctest"
  ];

  # tests/CMakeLists.txt uses FetchContent to download doctest; replace that
  # with the nixpkgs package and update the target to its namespaced form.
  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
        substituteInPlace tests/CMakeLists.txt \
          --replace-fail \
            'message(STATUS "Fetching doctest")
    include(FetchContent)
    FetchContent_Declare(doctest URL https://github.com/doctest/doctest/archive/refs/tags/v2.4.12.zip DOWNLOAD_EXTRACT_TIMESTAMP TRUE)
    FetchContent_MakeAvailable(doctest)' \
            'find_package(doctest REQUIRED)' \
          --replace-fail \
            'foonathan::lexy::unicode doctest)' \
            'foonathan::lexy::unicode doctest::doctest)'
  '';

  doCheck = true;

  # The default build exports only a Release CMake target. Consumers building
  # in Debug mode cannot resolve foonathan::lexy::file (a STATIC IMPORTED
  # target) and lose transitive INTERFACE_INCLUDE_DIRECTORIES from lexy::core.
  # Adding a Debug entry pointing at the same Release artifact fixes this.
  postInstall = ''
    local targets="$out/lib/cmake/lexy/lexyTargets-release.cmake"
    cat >> "$targets" << EOF

    set_property(TARGET foonathan::lexy::file
        APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
    set_target_properties(foonathan::lexy::file PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
        IMPORTED_LOCATION_DEBUG "$out/lib/liblexy_file.a")
    EOF
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Parser combinator library for C++17 and onwards";
    homepage = "https://github.com/foonathan/lexy";
    changelog = "https://github.com/foonathan/lexy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ foolnotion ];
  };
})
