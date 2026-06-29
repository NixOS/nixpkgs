{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
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
  ];

  cmakeFlags = [
    (lib.cmakeBool "LSL_UNIXFOLDERS" true)
    (lib.cmakeBool "LSL_FRAMEWORK" false)
    (lib.cmakeBool "LSL_BUNDLED_BOOST" false)
    (lib.cmakeBool "LSL_FETCH_PUGIXML" false)
    (lib.cmakeBool "LSL_BUILD_STATIC" stdenv.targetPlatform.isStatic)
  ];

  passthru.updateScript = nix-update-script { };

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
