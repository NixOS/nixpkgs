{
  cmake,
  stdenv,
  runCommand,
  lib,
  fetchFromGitHub,
  boost,
  catch2_3,
  pugixml,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblsl";
  version = "1.17.7-unstable-2026-06-17";

  src = fetchFromGitHub {
    owner = "sccn";
    repo = "liblsl";
    rev = "e651023ca67996a05a028fd88a28603297120294";
    hash = "sha256-hYG+sWnvY6NcapT3d+Kdf5nAXUBoDbiJRTGs/3sJV2k=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    pugixml
    catch2_3
  ];

  cmakeFlags = [
    (lib.cmakeBool "LSL_UNIXFOLDERS" true)
    (lib.cmakeBool "LSL_FRAMEWORK" false)
    (lib.cmakeBool "LSL_BUNDLED_BOOST" false)
    (lib.cmakeBool "LSL_FETCH_PUGIXML" false)
    (lib.cmakeBool "LSL_TESTS_PREFER_SYSTEM_CATCH2" true)
    (lib.cmakeBool "LSL_BUILD_STATIC" stdenv.targetPlatform.isStatic)
    (lib.cmakeBool "LSL_TOOLS" true)
    (lib.cmakeBool "LSL_UNITTESTS" true)
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      # TODO(@Pandapip1): currently fails, investigate why
      # exported = runCommand "lsl_test_exported" {
      #   nativeBuildInputs = [ finalAttrs.finalPackage ];
      # } "lsl_test_exported && touch $out";
      internal = runCommand "lsl_test_internal" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } "lsl_test_internal && touch $out";
      runtime_config = runCommand "lsl_test_runtime_config" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } "lsl_test_runtime_config && touch $out";
    };
  };

  meta = {
    description = "C++ lsl library for multi-modal time-synched data transmission over the local network";
    homepage = "https://github.com/sccn/liblsl";
    changelog = "https://github.com/sccn/liblsl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      abcsds
      pandapip1
    ];
    platforms = lib.platforms.all;
  };
})
