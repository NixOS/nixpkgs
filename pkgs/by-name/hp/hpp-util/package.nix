{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInput
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  boost,
  jrl-cmakemodules,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-util";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-util";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Op7bCaDOoKppEzj0wWNs52QhtdPTvMp+qEwW4ZA446M=";
  };

  prePatch = ''
    substituteInPlace tests/run_debug.sh.in \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

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
    boost
    jrl-cmakemodules
    tinyxml-2
  ];

  doCheck = true;

  meta = {
    description = "Debugging tools for the HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-util";
    changelog = "https://github.com/humanoid-path-planner/hpp-util/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
