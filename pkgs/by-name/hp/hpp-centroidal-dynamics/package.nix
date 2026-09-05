{
  lib,
  fetchFromGitHub,
  stdenv,

  pythonSupport ? false,
  python3Packages,

  # buildInputs
  cddlib,
  clp,
  jrl-cmakemodules,
  qpoases,

  # propagatedBuildInputs
  boost,
  eigen,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-centroidal-dynamics";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-centroidal-dynamics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-evmvgfZpW6OHFzhQPfRZ8rmGLBsfgJ0j4oOsnfZDge0=";
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
    cddlib
    clp
    jrl-cmakemodules
    qpoases
  ];

  propagatedBuildInputs = [
    eigen
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ]
  ++ lib.optional (!pythonSupport) boost;

  nativeCheckInputs = lib.optionals pythonSupport [
    python3Packages.pythonImportsCheckHook
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_WITH_CLP" true)
  ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_centroidal_dynamics" ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility classes to check the (robust) equilibrium of a system in contact with the environment.";
    homepage = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics";
    changelog = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
