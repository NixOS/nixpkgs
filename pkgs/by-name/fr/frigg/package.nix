{
  lib,
  fetchFromGitHub,
  stdenv,
  stdenvNoCC,
  buildPackages,
  gbenchmark,
  gtest,
  meson,
  mimalloc,
  ninja,
  pkg-config,
}:
let
  attrs = {
    pname = "frigg";
    version = "0-unstable-2026-08-17";

    src = fetchFromGitHub {
      owner = "managarm";
      repo = "frigg";
      rev = "81c88917f54f90c67ea14cbd52534a9d2a1eae13";
      sha256 = "sha256-PmFtx7UCS1rnpa+H8ElOXqYXLvpcJNqiovEMqYDoo+E=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];

    checkInputs = [
      gbenchmark
      gtest
      mimalloc
    ];

    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Lightweight C++ utilities and algorithms for system programming";
      homepage = "https://github.com/managarm/frigg";
      platforms = lib.platforms.all;
      license = with lib.licenses; [ mit ];
      maintainers = with lib.maintainers; [ lzcunt ];
    };
  };

  withTests = stdenv.mkDerivation (
    attrs
    // {
      doCheck = true;

      mesonFlags = [
        "-Dbuild_tests=enabled"
      ];
    }
  );
in
stdenvNoCC.mkDerivation (
  attrs
  // {
    passthru.tests.self = withTests;

    mesonFlags = [
      "-Dbuild_tests=disabled"
    ];
  }
)
