{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  php,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "magento-cloud";
  version = "1.47.0";

  src = fetchurl {
    url = "https://accounts.magento.cloud/sites/default/files/magento-cloud-v${finalAttrs.version}.phar";
    hash = "sha256-/CzHWQa/O1gW4x+b0acR0Cj8AE8Olhpgn7YcaDrLk9E=";
  };

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D ${finalAttrs.src} $out/libexec/magento-cloud/magento-cloud.phar
    makeWrapper ${lib.getExe php} $out/bin/magento-cloud \
      --add-flags "$out/libexec/magento-cloud/magento-cloud.phar"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://experienceleague.adobe.com/en/docs/commerce-cloud-service/user-guide/dev-tools/cloud-cli/cloud-cli-overview";
    description = "Adobe Commerce Cloud CLI";
    longDescription = ''
      Adobe Commerce Cloud CLI enables developers and system administrators the ability to manage Cloud projects and environments, perform routines and run automation tasks locally.
    '';
    mainProgram = "magento-cloud";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
    license = lib.licenses.unfree;
  };
})
