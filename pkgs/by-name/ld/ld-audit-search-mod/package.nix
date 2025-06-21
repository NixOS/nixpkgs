{
  lib,
  stdenv,
  spdlog,
  yaml-cpp,
  cmake,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ld-audit-search-mod";
  version = "0-unstable-2025-06-19";

  src = fetchFromGitHub {
    repo = finalAttrs.pname;
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

  preConfigure = ''
    nix_rtld_path=$(cat ${stdenv.cc}/nix-support/dynamic-linker)
    nix_rtld_name=$(basename $nix_rtld_path)
    cmakeFlagsArray+=(
      "-DNIX_RTLD_NAME=$nix_rtld_name"
      "-DNIX_STORE_DIR=$NIX_STORE"
    )
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Audit module that modifies ld.so library search behavior";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
