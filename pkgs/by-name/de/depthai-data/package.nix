{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "depthai-data";
  # DepthAI v3.0.0-beta.1
  version = "0-unstable-2025-05-22";

  src = fetchFromGitHub {
    owner = "phodina";
    repo = "depthai-data";
    rev = "3b7dc1d3ddde1961c5d47b5188993fc9b3860349";
    hash = "sha256-wdgPziAilht/e3LEjSnYPwfbNgrG22fXdA0cQ6wl4zE=";
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
