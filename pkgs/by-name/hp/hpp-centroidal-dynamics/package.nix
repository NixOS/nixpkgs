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

  # buildInputs
  cddlib,
  clp,
  qpoases,

  # propagatedBuildInputs
  boost,
  eigen,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-centroidal-dynamics";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-centroidal-dynamics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DfxIyz7lylh+z38BrJhRwyBYQ9nvBW/3CI7dieJ/g+o=";
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
  buildInputs = [
    cddlib
    clp
    qpoases
  ];
  propagatedBuildInputs =
    [
      eigen
      jrl-cmakemodules
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
    ]
    ++ lib.optional (!pythonSupport) boost;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_CLP" true)
  ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_centroidal_dynamics" ];

  meta = {
    description = "Utility classes to check the (robust) equilibrium of a system in contact with the environment.";
    homepage = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics";
    changelog = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
