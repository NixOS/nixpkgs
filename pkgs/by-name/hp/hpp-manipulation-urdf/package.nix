{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  hpp-manipulation,

  # checkInputs
  example-robot-data,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation-urdf";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-urdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t62zULwKR5MSoEcsWt/NYr8ojS1Ca0tSXlR9NYwtSLY=";
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
  ];
  propagatedBuildInputs = [ hpp-manipulation ];
  checkInputs = [ example-robot-data ];
  doCheck = true;

  preCheck = ''
    export ROS_PACKAGE_PATH=${example-robot-data}/share
  '';

  meta = {
    description = "Implementation of a parser for hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
