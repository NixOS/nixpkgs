{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
  replaceVars,
  symlinkJoin,
  cmake,
  doxygen,
  ruby,
  validatePkgConfig,
  testers,
  unity-test,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iniparser";
  version = "4.2.6";

  src = fetchFromGitLab {
    owner = "iniparser";
    repo = "iniparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z10S9ODLprd7CbL5Ecgh7H4eOwTetYwFXiWBUm6fIr4=";
  };

  patches = lib.optional finalAttrs.doCheck (
    # 1. Do not fetch the Unity GitHub repository
    # 2. Lookup the Unity pkgconfig file
    # 3. Get the generate_test_runner.rb file from the Unity share directory
    replaceVars ./remove-fetchcontent-usage.patch {
      # Get the test generator
      UNITY-GENERATE-TEST-RUNNER = "${unity-test}/share/generate_test_runner.rb";
    }
  );

  nativeBuildInputs = [
    cmake
    doxygen
    validatePkgConfig
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];
  doCheck = true;
  nativeCheckInputs = [
    ruby
    ctestCheckHook
  ];
  checkInputs = [
    (
      (unity-test.override {
        supportDouble = true;
      }).overrideAttrs
      {
        doCheck = false;
      }
    )
  ];

  postFixup = ''
    ln -sv $out/include/iniparser/*.h $out/include/
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://gitlab.com/iniparser/iniparser";
    description = "Free standalone ini file parsing library";
    changelog = "https://gitlab.com/iniparser/iniparser/-/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "iniparser" ];
    maintainers = [ ];
  };
})
