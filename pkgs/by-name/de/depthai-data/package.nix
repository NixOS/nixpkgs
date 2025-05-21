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
    rev = "4d010261561f614009acdbb763dc2f132f0d8401";
    hash = "sha256-Yo54QttxC6/KVIrM2fpAol2f23Vq1IL2oSvBEQ0Ovek=";
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
