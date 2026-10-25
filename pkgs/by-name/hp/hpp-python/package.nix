{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  python3Packages,

  # propagatedBuildInputs
  jrl-cmakemodules,
  hpp-util,
  hpp-pinocchio,
  hpp-constraints,
  hpp-core,
  hpp-manipulation,
  hpp-manipulation-urdf,

  # checkInputs
  example-robot-data,
  hpp-environments,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-python";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2vbwujdCcDem1q1Iw45euTMeHZnnlvrnAufkSRMzwko=";
  };

  prePatch = ''
    patchShebangs doc/configure.py
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.pybind11-stubgen
  ];

  buildInputs = [
    jrl-cmakemodules
    python3Packages.boost
  ];

  propagatedBuildInputs = [
    hpp-util
    hpp-pinocchio
    hpp-constraints
    hpp-core
    hpp-manipulation
    hpp-manipulation-urdf
    python3Packages.eigenpy
    python3Packages.lxml
    python3Packages.pinocchio
  ];

  checkInputs = [
    example-robot-data
    hpp-environments
  ];

  nativeCheckInputs = [
    python3Packages.pythonImportsCheckHook
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  pythonImportsCheck = [
    "pyhpp"
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "python bindings for HPP, based on boost python";
    homepage = "https://github.com/humanoid-path-planner/hpp-python/";
    changelog = "https://github.com/humanoid-path-planner/hpp-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.linux; # TODO: macos
  };
})
