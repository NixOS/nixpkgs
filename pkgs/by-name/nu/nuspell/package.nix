{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  buildPackages,
  pkg-config,
  icu,
  catch2_3,
  testers,
  enableManpages ? buildPackages.pandoc.compiler.bootstrapAvailable,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nuspell";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/lHSxpKsBnamf4ikE2aIjEPSU5fxjtuSmhZR0jxMAI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional enableManpages buildPackages.pandoc;

  strictDeps = true;
  buildInputs = [ catch2_3 ];

  propagatedBuildInputs = [ icu ];

  cmakeFlags = lib.optional (!enableManpages) "-DBUILD_DOCS=OFF";

  nativeCheckInputs = [
    ctestCheckHook
  ];

  doCheck = true;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  passthru = {
    withDicts = callPackage ./wrapper.nix { nuspell = finalAttrs.finalPackage; };

    tests = {
      wrapper = testers.testVersion {
        package = finalAttrs.finalPackage.withDicts (d: [ d.en_US ]);
      };

      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

      cmake = testers.hasCmakeConfigModules {
        moduleNames = [ "Nuspell" ];
        package = finalAttrs.finalPackage;
        version = finalAttrs.version;
        versionCheck = true;
      };
    };
  };

  meta = {
    description = "Free and open source C++ spell checking library";
    mainProgram = "nuspell";
    pkgConfigModules = [ "nuspell" ];
    homepage = "https://nuspell.github.io/";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.lgpl3Plus;
    changelog = "https://github.com/nuspell/nuspell/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
