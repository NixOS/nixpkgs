{
  cmake,
  doxygen,
  fetchFromGitHub,
  hpp-pinocchio,
  hpp-statistics,
  lib,
  pkg-config,
  qpoases,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-constraints";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-constraints";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5x5PvuxNP1iaXmwQJhg0UWlo7kPCzF3xgbUwenZ1xqk=";
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
  propagatedBuildInputs = [
    hpp-pinocchio
    hpp-statistics
    qpoases
  ];

  doCheck = true;

  meta = {
    description = "Definition of basic geometric constraints for motion planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-constraints";
    changelog = "https://github.com/humanoid-path-planner/hpp-constraints/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
