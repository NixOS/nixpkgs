{
  stdenvNoCC,
  fetchurl,
  lib,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mpm-unwrapped";
  version = "2026.7";

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      source =
        finalAttrs.passthru.supportedPlatforms.${system}
          or (throw "Platform ${system} is not supported by mpm");
    in
    fetchurl {
      url = "https://ssd.mathworks.com/supportfiles/downloads/mpm/${finalAttrs.version}/${source.mathworks_platform}/mpm";
      inherit (source) hash;
    };

  dontUnpack = true;

  __structuredAttrs = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall
    install -D ${finalAttrs.src} $out/bin/mpm
    runHook postInstall
  '';

  doInstallCheck = stdenvNoCC.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    supportedPlatforms = {
      "aarch64-darwin" = {
        mathworks_platform = "maca64";
        hash = "sha256-mVEoHkcU3uhMC1dYVZTUw8+/TchdzRd/SNdm3RcmlQc=";
      };
      "x86_64-linux" = {
        mathworks_platform = "glnxa64";
        hash = "sha256-zdEGLcjTDeIQPr+HE8sZNdcy222QppcY4NSWFjJfP+8=";
      };
    };

    updateScript = ./update.sh;
  };

  meta = {
    description = "MATLAB Package Manager";
    homepage = "https://www.mathworks.com/products/mpm.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sopyb ];
    platforms = lib.attrNames finalAttrs.passthru.supportedPlatforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "mpm";
  };
})
