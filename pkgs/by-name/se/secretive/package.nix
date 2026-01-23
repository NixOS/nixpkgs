{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "secretive";
  version = "3.0.4";

  src = fetchzip {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${finalAttrs.version}/Secretive.zip";
    hash = "sha256-dZqcYnEHaeUN92lYIlGcv3qXPEIKY5z1LLJiSyeY2BM=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Secretive.app "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Store SSH keys in the Secure Enclave";
    homepage = "https://github.com/maxgoedjen/secretive";
    changelog = "https://github.com/maxgoedjen/secretive/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shgew ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
