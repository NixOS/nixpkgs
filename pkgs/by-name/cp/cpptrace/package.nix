{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libdwarf,
  gtest,
  callPackage,
  zstd,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpptrace";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "cpptrace";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zjPxPtq+OQ104sJoeBD3jpMV9gV57FSHEJS4W6SF8GM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libdwarf ];
  propagatedBuildInputs = [ zstd ];

  cmakeFlags = [
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_LIBDWARF" true)
    (lib.cmakeBool "CPPTRACE_FIND_LIBDWARF_WITH_PKGCONFIG" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_GTEST" true)
  ];

  checkInputs = [ gtest ];

  # Unit tests are flaky and hard to get right.
  doCheck = false;

  passthru.tests = {
    findpackage-integration = callPackage ./findpackage-integration.nix {
      src = "${finalAttrs.src}/test/findpackage-integration";
      checkOutput = finalAttrs.finalPackage.doCheck;
    };
  };

  meta = {
    changelog = "https://github.com/jeremy-rifkin/cpptrace/releases/tag/v${finalAttrs.version}";
    description = "Simple, portable, and self-contained stacktrace library for C++11 and newer";
    homepage = "https://github.com/jeremy-rifkin/cpptrace";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xokdvium ];
    platforms = lib.platforms.all;
  };
})
