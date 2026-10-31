{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  gtest,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libevents";
  version = "0-unstable-2026-09-27";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "mavlink";
    repo = "libevents";
    rev = "0ef305faa4cffdb09f01ca862ebfc108b7ff0cd5";
    hash = "sha256-DcuY5Z3ZgsA+Je6NHVqOKaanP6FdYdetfG8qHKtZ/GM=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/cpp";

  # Upstream installs common/, parse/ and protocol/ but not generated/, even
  # though that header is part of the library's public API (consumers are
  # expected to vendor the checkout directly). TODO: Upstream.
  patches = [ ./install-generated-header.patch ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTING" true)
    # Tests FetchContent-fetch googletest; point that at gtest's own source
    # instead of hitting the network.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    # googletest's own CMakeLists.txt would otherwise build and install gmock
    # and install gtest itself straight into our output.
    (lib.cmakeBool "BUILD_GMOCK" false)
    (lib.cmakeBool "INSTALL_GTEST" false)
  ];

  nativeBuildInputs = [ cmake ];

  # python3 is also needed unconditionally during the normal build, not just
  # checkPhase: ENABLE_TESTING above makes the test executables (which the
  # generated events header is a dependency of) part of the default build
  # target. doCheck = true below merges this into nativeBuildInputs too.
  nativeCheckInputs = [
    ctestCheckHook
    (python3.withPackages (ps: [ ps.jinja2 ]))
  ];

  # enable_testing() is only called in tests/CMakeLists.txt, not at the top
  # level, so there's no top-level CTestTestfile.cmake for a plain `ctest` to
  # find the tests through.
  ctestFlags = [
    "--test-dir"
    "tests"
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "C++ library for the MAVLink events protocol (health/arming checks, event parsing)";
    homepage = "https://github.com/mavlink/libevents";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
