{
  lib,
  fetchFromGitHub,
  stdenv,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  hpp-core,
  hpp-universal-robot,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aljpqMqEJ7ZnwkbuDGkortYxeRZ3vcPquJp7MR6kXc0=";
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
    hpp-core
    hpp-universal-robot
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Classes for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
