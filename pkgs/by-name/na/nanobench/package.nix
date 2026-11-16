{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanobench";
  version = "4.6.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "martinus";
    repo = "nanobench";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FN/w20icNirj3ah0l7FNvG8ooZcAaZCKVtag9Rv7nn8=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  cmakeFlags = [ (lib.cmakeBool "NANOBENCH_BUILD_TEST" finalAttrs.finalPackage.doCheck) ];

  checkPhase = ''
    runHook preCheck
    ./nb
    runHook postCheck
  '';

  passthru = {
    tests.cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "nanobench" ];
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple, fast, accurate single-header microbenchmarking functionality for C++11/14/17/20";
    homepage = "https://nanobench.ankerl.com/";
    changelog = "https://github.com/martinus/nanobench/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mtpham99 ];
  };
})
