{
  lib,
  fetchFromGitHub,
  stdenv,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  example-robot-data,
  hpp-environments,
  hpp-util,
  pinocchio,

  # nativeCheckInputs
  ctestCheckHook,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-pinocchio";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-pinocchio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tsRw3AFH8Jn3xYGY/g63DxdCbgFaQaNnTuJLRmFgTWM=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  propagatedBuildInputs = [
    example-robot-data
    hpp-environments
    hpp-util
    pinocchio
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  disabledTests = [
    # boost serialization issue
    "device"
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrapping of Pinocchio library into HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-pinocchio";
    changelog = "https://github.com/humanoid-path-planner/hpp-pinocchio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
