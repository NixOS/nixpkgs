{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "depthai-data";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "amronos";
    repo = "depthai-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Wkj+e8TTrn4EjDU36R91F71XbyaNArIOJpnEY9D418=";
  };

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/resources
    cp -r ./data/. $out/share/resources/
  '';

  meta = {
    description = " DepthAI camera calibration and neural network data files used by depthai-core";
    homepage = "https://github.com/Amronos/depthai-data";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      amronos
    ];
  };
})
