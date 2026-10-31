{
  lib,
  fetchFromGitHub,
  stdenv,

  # propagatedBuildInputs
  hpp-manipulation,

  # buildInputs
  jrl-cmakemodules,

  # checkInputs
  example-robot-data,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation-urdf";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-urdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZT5CnOnT90gLNXnjqk7wOIiV623d3dTqxY+8T6m9SA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    hpp-manipulation
  ];

  checkInputs = [
    example-robot-data
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of a parser for hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
