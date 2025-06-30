{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  withStatic ? stdenv.hostPlatform.isStatic,
  withShared ? !withStatic,
  buildExamples ? false,
}:

# Ensure build examples with static library.
assert buildExamples -> withStatic;

stdenv.mkDerivation (finalAttrs: {
  pname = "sobjectizer";
  version = "5.8.4";

  src = fetchFromGitHub {
    owner = "Stiffstream";
    repo = "sobjectizer";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-tIqWgd6TppHfqZk3XHzhG0t+Nn8BQCTP81UD7ls67UE=";
  };

  patches = [
    (fetchpatch {
      name = "tests-do-not-require-static-library.patch";
      url = "https://github.com/Stiffstream/sobjectizer/commit/10eb34c65ccdaa4fea62d0c4354b83104256370d.patch";
      hash = "sha256-a2g6jDGDC/y8cmbAD0KtVQKhVS5ZAjKtMhbAUyoQIvg=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeDir = "../dev";

  cmakeFlags = [
    (lib.cmakeBool "SOBJECTIZER_BUILD_STATIC" withStatic)
    (lib.cmakeBool "SOBJECTIZER_BUILD_SHARED" withShared)
    (lib.cmakeBool "BUILD_EXAMPLES" (buildExamples && withStatic))
    (lib.cmakeBool "BUILD_TESTS" (finalAttrs.doCheck && withShared))
  ];

  # The tests require the shared library thanks to the patch.
  doCheck = withShared;

  # Receive semi-automated updates.
  passthru.updateScript = pkgs.nix-update-script { };

  meta = {
    homepage = "https://github.com/Stiffstream/sobjectizer/tree/master";
    changelog = "https://github.com/Stiffstream/sobjectizer/releases/tag/v.${finalAttrs.version}";
    description = "Implementation of Actor, Publish-Subscribe, and CSP models in one rather small C++ framework";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ivalery111 ];
    platforms = lib.platforms.all;
  };
})
