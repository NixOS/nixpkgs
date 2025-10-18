{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  omniorb,
  pkg-config,
  python3Packages,

  # propagatedBuildInputs
  hpp-manipulation-urdf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation-corba";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-corba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WG2CqkC0Jhwi10hQ9kjtGM5bQiuqeNj0JIKYQwOoCEQ=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    omniorb
    pkg-config
    python3Packages.python
  ];
  propagatedBuildInputs = [
    hpp-manipulation-urdf
    python3Packages.hpp-corbaserver
    python3Packages.omniorbpy
  ];

  enableParallelBuilding = false;

  doCheck = true;

  meta = {
    description = "Corba server for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-corba";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation-corba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
