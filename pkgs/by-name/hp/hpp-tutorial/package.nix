{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-tutorial";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-tutorial";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LD+2e1vLY74i5u5sn0XUA0iyGTuRRLaYSa5q1m+Hc6Q=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    python3Packages.hpp-gepetto-viewer
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tutorial for humanoid path planner platform";
    homepage = "https://github.com/humanoid-path-planner/hpp-tutorial";
    changelog = "https://github.com/humanoid-path-planner/hpp-tutorial/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
