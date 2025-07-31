{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  storeDir ? builtins.storeDir,
  spdlog,
  yaml-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ld-audit-search-mod";
  version = "0-unstable-2025-06-19";

  src = fetchFromGitHub {
    repo = "ld-audit-search-mod";
    owner = "DDoSolitary";
    rev = "261f475f154d0f1f0766d6756af9c714eeeb14ea";
    hash = "sha256-c6ub+m4ihIE3gh6yHtLfJIVqm12C46wThrBCqp8SOLE=";
    sparseCheckout = [ "src" ];
  };
  sourceRoot = "${finalAttrs.src.name}/src";

  buildInputs = [
    spdlog
    yaml-cpp
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeFeature "NIX_RTLD_NAME" (builtins.baseNameOf stdenv.cc.bintools.dynamicLinker))
    (lib.cmakeFeature "NIX_STORE_DIR" storeDir)
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Audit module that modifies ld.so library search behavior";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.atry
      lib.maintainers.DDoSolitary
    ];
    platforms = lib.platforms.linux;
  };
})
