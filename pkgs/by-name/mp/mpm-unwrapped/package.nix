{
  stdenvNoCC,
  fetchurl,
  lib,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mpm-unwrapped";
  version = "2026.3";

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

  installPhase = ''
    runHook preInstall
    install -D "$src" "$out"/bin/mpm
    runHook postInstall
  '';

  # NOTE: Sandboxed binary can't run on Linux hosts during build.
  # However, it will work on non-NixOS Linux after installation.
  # Use `pkgs.mpm` on NixOS and/or if you need `versionCheckHook` enabled
  doInstallCheck = stdenvNoCC.hostPlatform.isDarwin;
  nativeInstallCheckInputs = [ versionCheckHook ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.supportedPlatforms = {
    "aarch64-darwin" = {
      mathworks_platform = "maca64";
      hash = "sha256-ESqG7cmVvWfilKN/pM/f6bxPv5Vs8wJ5p2Ne8DD4dI8=";
    };
    "x86_64-linux" = {
      mathworks_platform = "glnxa64";
      hash = "sha256-lsCa2xT0mXUGunNcs2PsE04ItOOybxlQhmNuKa/qs6M=";
    };
  };

  meta = {
    description = "MATLAB Package Manager";
    homepage = "https://www.mathworks.com/products/mpm.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ djmaxus ];
    platforms = lib.attrNames finalAttrs.passthru.supportedPlatforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "mpm";
  };
})
