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
  nix-update-script,
  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpptrace";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "cpptrace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3BnAWRpKJR5lsokpmbOLUIQGuiH46AM1NQwOtBl28AA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libdwarf ];
  propagatedBuildInputs = [ zstd ] ++ (lib.optionals static [ libdwarf ]);

  cmakeFlags = [
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_LIBDWARF" true)
    (lib.cmakeBool "CPPTRACE_FIND_LIBDWARF_WITH_PKGCONFIG" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!static))
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_GTEST" true)
  ];

  checkInputs = [ gtest ];
  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests =
      let
        mkIntegrationTest =
          { static }:
          callPackage ./findpackage-integration.nix {
            src = "${finalAttrs.src}/test/findpackage-integration";
            checkOutput = finalAttrs.finalPackage.doCheck;
            inherit static;
          };
      in
      {
        findpackage-integration-shared = mkIntegrationTest { static = false; };
        findpackage-integration-static = mkIntegrationTest { static = true; };
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
