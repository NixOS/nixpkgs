{
  lib,
  fetchFromGitHub,
  stdenv,

  python3Packages,
  pythonSupport ? false,

  # propagatedBuildInputs
  boost,
  example-robot-data,
  jrl-cmakemodules,
  pinocchio,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-environments";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-environments";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/OWs5XHA03GNZTpUxuuQ5qbe6LEFV+PKhfyBEDFVCc=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs =
    jrl-cmakemodules.docsNativeBuildInputs ++ lib.optional pythonSupport python3Packages.python;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs =
    lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
      python3Packages.pinocchio
      python3Packages.example-robot-data
    ]
    ++ lib.optionals (!pythonSupport) [
      boost
      pinocchio
      example-robot-data
    ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Environments and robot descriptions for HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-environments";
    changelog = "https://github.com/humanoid-path-planner/hpp-environments/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
