{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  pkg-config,
  omniorb,

  # propagatedBuildInputs
  hpp-util,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-template-corba";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-template-corba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uDMf2p/9GS62lh7I0ZYYLaPe/d6W++cJhtwBIKf1G+U=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    omniorb
  ];
  propagatedBuildInputs = [
    jrl-cmakemodules
    hpp-util
    omniorb
  ];

  doCheck = true;

  meta = {
    description = "This package is intended to ease construction of CORBA servers by templating actions that are common to all servers";
    homepage = "https://github.com/humanoid-path-planner/hpp-template-corba";
    changelog = "https://github.com/humanoid-path-planner/hpp-template-corba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
