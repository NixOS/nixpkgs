{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "magento-cache-clean";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "mage-os";
    repo = "magento-cache-clean";
    tag = finalAttrs.version;
    hash = "sha256-J1Tg6PyW/IdXv9B2YoAH1z93TJyaWpsMvca9+n8p6AQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/magento-cache-clean $out/bin
    cp -r bin node_modules $out/lib/magento-cache-clean/

    makeWrapper ${lib.getExe nodejs} $out/bin/cache-clean.js \
      --add-flags "$out/lib/magento-cache-clean/bin/cache-clean.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "File watcher based cache cleaner for Magento 2";
    homepage = "https://github.com/mage-os/magento-cache-clean";
    changelog = "https://github.com/mage-os/magento-cache-clean/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
    mainProgram = "cache-clean.js";
  };
})
