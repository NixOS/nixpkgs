{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "depthai-data";
  # DepthAI v3 alpha 15
  version = "0-unstable-2025-04-21";

  src = fetchFromGitHub {
    owner = "phodina";
    repo = "depthai-data";
    rev = "2c7e6a5cf55d95eb94e522a1cd512441524d031c";
    hash = "sha256-T4qLkmLtQUei509tqTPfnzz8AQRQ1MiHniZzH172im8=";
  };

  # No build phase needed, this is just data
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/resources
    cp -r * $out/share/resources/
    rm $out/share/resources/README.md
  '';

  meta = {
    description = "DepthAI camera calibration and neural network data files";
    homepage = "https://github.com/phodina/depthai-data";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ phodina ];
  };
})
