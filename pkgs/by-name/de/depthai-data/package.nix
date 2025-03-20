{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "depthai-data";
  version = "3.0.0-alpha.14";

  src = fetchFromGitHub {
    owner = "phodina";
    repo = "depthai-data";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-myNBYWyQifQf+hyCKpLGS01iW/oRrb5tzW6dQqZbCHg=";
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
