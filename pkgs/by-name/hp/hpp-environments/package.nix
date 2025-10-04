{
  lib,
  fetchFromGitHub,
  stdenv,

  python3Packages,
  pythonSupport ? false,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  boost,
  example-robot-data,
  jrl-cmakemodules,
  pinocchio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-environments";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-environments";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GCyrt1SkBrfoT2VXrZOoOlysxH4gS2+n5pNYSuAbAs8=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ] ++ lib.optional pythonSupport python3Packages.python;
  propagatedBuildInputs =
    [
      jrl-cmakemodules
    ]
    ++ lib.optionals pythonSupport [
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

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  meta = {
    description = "Environments and robot descriptions for HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-environments";
    changelog = "https://github.com/humanoid-path-planner/hpp-environments/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
