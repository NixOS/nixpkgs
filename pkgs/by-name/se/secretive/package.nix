{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "secretive";
  version = "3.0.3";

  src = fetchzip {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${finalAttrs.version}/Secretive.zip";
    hash = "sha256-zjgd6gpb/FBRekOFJNpBFbsDmsx6HBWgshm5s5n2T5w=";
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
