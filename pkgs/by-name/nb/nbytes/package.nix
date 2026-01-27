{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch2,
  gtest,
  nix-update-script,
  stdenv,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbytes";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "nbytes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lsd1Qrv1HEz/5ry10s7Pq7unoh3y9ZmwCaT+6nTlxkc=";
  };

  patches = [
    # Use `gtest` from Nixpkgs to allow an offline build
    ./use-nix-googletest.patch
    # Add support for pkgconfig for use as a shared lib
    # TODO: remove when included in the next release
    (fetchpatch2 {
      url = "https://github.com/nodejs/nbytes/commit/00f48a0620cef800054d4aab061f09d89990a1b9.patch?full_index=1";
      hash = "sha256-uOPEI70Dq446K56BSFHVyxDHNaYY5OASu3QeWGCLQmI=";
    })
  ];

  outputs = [
    "out"
  ];

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];
  buildInputs = [
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru = {
    updateScript = nix-update-script { };

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Library of byte handling functions extracted from Node.js core";
    homepage = "https://github.com/nodejs/nbytes";
    changelog = "https://github.com/nodejs/nbytes/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "nbytes" ];
  };
})
