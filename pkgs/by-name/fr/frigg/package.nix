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
    version = "0-unstable-2026-09-20";

    src = fetchFromGitHub {
      owner = "managarm";
      repo = "frigg";
      rev = "9bd9c7ba5d2d654fcabf4857373ff7538e304c86";
      sha256 = "sha256-zZQhNHZ1X9Ty7cJwmLV2PSUImRoLyDOPjxMY93lc2Lo=";
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

    # The test suite builds variadic test code with clang 21, where
    # -fstack-clash-protection omits varargs XMM register saves
    # (https://github.com/llvm/llvm-project/issues/178268), making
    # va_arg(..., double) return garbage in the printf tests.
    hardeningDisable = [ "stackclashprotection" ];

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
      depsBuildBuild = [
        stdenv.cc
      ];

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
