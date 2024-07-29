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
  example-robot-data,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-universal-robot";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-universal-robot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4sZPcFV/vDtWDnjaBcGzCpS9SWYa3S0LzgUYdrT9vzM=";
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
  propagatedBuildInputs = [
    jrl-cmakemodules
    example-robot-data
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  meta = {
    description = "Data specific to robots ur5 and ur10 for hpp-corbaserver";
    homepage = "https://github.com/humanoid-path-planner/hpp-universal-robot";
    changelog = "https://github.com/humanoid-path-planner/hpp-universal-robot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
