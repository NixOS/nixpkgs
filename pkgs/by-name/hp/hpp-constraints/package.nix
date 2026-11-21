{
  lib,
  fetchFromGitHub,
  stdenv,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  hpp-pinocchio,
  hpp-statistics,
  qpoases,

  # nativeCheckInputs
  ctestCheckHook,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-constraints";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-constraints";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dEnbNDo5OeJDHM3bpfAeXcLTsfPQbag5iLOAXh7rTFQ=";
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
    hpp-pinocchio
    hpp-statistics
    qpoases
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  disabledTests = [
    # numerical issue
    "test-jacobians"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "solver-by-substitution'"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Definition of basic geometric constraints for motion planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-constraints";
    changelog = "https://github.com/humanoid-path-planner/hpp-constraints/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
