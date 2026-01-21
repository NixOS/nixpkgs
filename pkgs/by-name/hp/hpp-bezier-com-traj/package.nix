{
  lib,
  fetchFromGitHub,
  stdenv,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  cddlib,
  clp,
  glpk,
  hpp-centroidal-dynamics,
  ndcurves,
  qpoases,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-bezier-com-traj";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-bezier-com-traj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5G7FD/LNfygFHNk5btx0PrkUqWWdSpJwazb1I+CJhy4=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs =
    [
      cmake
      doxygen
      pkg-config
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.pythonImportsCheckHook
    ];
  propagatedBuildInputs =
    [
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

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
      (lib.cmakeBool "USE_GLPK" true)
    ]
    ++ lib.optionals stdenv.targetPlatform.isDarwin [
      (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'transition'")
    ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_bezier_com_traj" ];

  meta = {
    description = "Multi contact trajectory generation for the COM using Bezier curves";
    homepage = "https://github.com/humanoid-path-planner/hpp-bezier-com-traj";
    changelog = "https://github.com/humanoid-path-planner/hpp-bezier-com-traj/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
