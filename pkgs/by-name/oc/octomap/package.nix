{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages,
  testers,
  enableOpenmp ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "octomap";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = "octomap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oCBvmYbFZ9aSn/3ljItccrrvaBHngshvn2HTLTzN8kg=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  sourceRoot = "${finalAttrs.src.name}/octomap";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optional (enableOpenmp && stdenv.cc.isClang) llvmPackages.openmp;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "OCTOMAP_USE_OPENMP" enableOpenmp)
  ];

  doCheck = true;

  passthru = {
    inherit enableOpenmp;
    tests = {
      cmake-config = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage;
      };
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
    };
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/OctoMap/octomap/releases/tag/${finalAttrs.src.tag}";
    description = "Probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      lopsided98
      nim65s
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    cmakeConfigModules = [ "octomap" ];
    pkgConfigModules = [ "octomap" ];
  };
})
