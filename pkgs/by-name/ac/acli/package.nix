{
  lib,
  stdenvNoCC,
  fetchurl,
  versionCheckHook,
  installShellFiles,

  writeShellApplication,
  curl,
  gnugrep,
  common-updater-scripts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "acli";
  version = "1.3.4";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 acli $out/bin/acli

    ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      installShellCompletion --cmd acli \
        --bash <($out/bin/acli completion bash) \
        --fish <($out/bin/acli completion fish) \
        --zsh <($out/bin/acli completion zsh)

      mkdir -p $out/share/powershell
      $out/bin/acli completion powershell > $out/share/powershell/acli.Completion.ps1
    ''}

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://acli.atlassian.com/linux/${finalAttrs.version}-stable/acli_${finalAttrs.version}-stable_linux_amd64.tar.gz";
        hash = "sha256-5jnzsRX4sPfemdMhW+uBDSv1QjLF/hjA8Jrel16bRZM=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://acli.atlassian.com/linux/${finalAttrs.version}-stable/acli_${finalAttrs.version}-stable_linux_arm64.tar.gz";
        hash = "sha256-biIDWOd94HHZ/+zqw/J3vuWXdBXYuNvgLkftNHB9S8g=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://acli.atlassian.com/darwin/${finalAttrs.version}-stable/acli_${finalAttrs.version}-stable_darwin_arm64.tar.gz";
        hash = "sha256-DVKCO057OObTSDF3c76svFKfebkbLDCKKFsRpIj2AEk=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://acli.atlassian.com/darwin/${finalAttrs.version}-stable/acli_${finalAttrs.version}-stable_darwin_amd64.tar.gz";
        hash = "sha256-LsVUPKZzpvsMuD8D8wN6+1KocJ8Ujx0UMv9D+tQ/WuI=";
      };
    };
    updateScript = lib.getExe (writeShellApplication {
      name = "update-acli";
      runtimeInputs = [
        curl
        gnugrep
        common-updater-scripts
      ];
      text = ''
        NEW_VERSION=$(curl --fail -L -s https://developer.atlassian.com/cloud/acli/changelog/ | grep -oP 'Atlassian CLI v([0-9]+\.[0-9]+\.[0-9]+)-stable' | head -n1 | sed -E 's/.*v(.*)-stable/\1/')

        if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
            echo "The new version same as the old version."
            exit 0
        fi

        for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
          update-source-version "acli" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
        done
      '';
    });
  };

  meta = {
    description = "Atlassian Command Line Interface";
    homepage = "https://developer.atlassian.com/cloud/acli/guides/introduction";
    maintainers = with lib.maintainers; [ moraxyc ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "acli";
  };
})
