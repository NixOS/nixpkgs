{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  php,
  testers,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "magento-cloud";
  version = "1.46.1";

  src = fetchurl {
    url = "https://accounts.magento.cloud/sites/default/files/magento-cloud-v${finalAttrs.version}.phar";
    hash = "sha256-QrrD5pz6Juov1u3QYcuLr6aEKe/4DX5wFKs+hp6KjJ8=";
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

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$TMPDIR magento-cloud --version";
    };
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
