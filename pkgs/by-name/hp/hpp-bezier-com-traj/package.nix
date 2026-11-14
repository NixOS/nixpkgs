{
  lib,
  fetchFromGitHub,
  stdenv,

  pythonSupport ? false,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  cddlib,
  clp,
  glpk,
  hpp-centroidal-dynamics,
  ndcurves,
  qpoases,

  # nativeCheckInputs
  ctestCheckHook,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-bezier-com-traj";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-bezier-com-traj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G/ZhCUmrMqKXiNJ9fti9wdRLbFK1cCvr5/S3w7WgTsA=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs =
    jrl-cmakemodules.docsNativeBuildInputs
    ++ lib.optionals pythonSupport [
      python3Packages.python
    ];

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    cddlib
    clp
    glpk
    qpoases
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.hpp-centroidal-dynamics
    python3Packages.ndcurves
  ]
  ++ lib.optionals (!pythonSupport) [
    hpp-centroidal-dynamics
    ndcurves
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.pythonImportsCheckHook
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "USE_GLPK" true)
  ];

  disabledTests = lib.optionals stdenv.targetPlatform.isDarwin [
    "transition"
  ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_bezier_com_traj" ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi contact trajectory generation for the COM using Bezier curves";
    homepage = "https://github.com/humanoid-path-planner/hpp-bezier-com-traj";
    changelog = "https://github.com/humanoid-path-planner/hpp-bezier-com-traj/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
