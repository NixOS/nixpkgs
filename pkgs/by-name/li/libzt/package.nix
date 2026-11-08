{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libzt";
  version = "1.8.10-unstable-2024-11-07";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "libzt";
    rev = "a707ea6ae0910efdc1125d04758c411e2e9ea4f9";
    fetchSubmodules = true;
    hash = "sha256-7XlMdyyo49fS1mXFll6SM0u5GH+HzxuDYbIpjjRJyvs=";
  };

  # Bundled prometheus-cpp-lite relies on <stdexcept> being included transitively,
  # which no longer holds with recent libstdc++
  postPatch = ''
    for f in family.h registry.h; do
      substituteInPlace ext/ZeroTierOne/ext/prometheus-cpp-lite-1.0/core/include/prometheus/$f \
        --replace-fail '#pragma once' $'#pragma once\n#include <stdexcept>'
    done
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # upstream (and bundled lwip) still declare cmake_minimum_required(VERSION 3.0)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
    # needs network access
    (lib.cmakeBool "BUILD_HOST_SELFTEST" false)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ZeroTier library for embedding P2P virtual networking in applications";
    homepage = "https://github.com/zerotier/libzt";
    # BSL 1.1 whose Change Date (2026-01-01) has passed
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    platforms = lib.platforms.unix;
  };
})
