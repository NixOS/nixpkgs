{
  lib,
  stdenv,
  fetchzip,
  coreutils,
  installShellFiles,
  makeWrapper,
  gitMinimal,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gk-cli";
  version = "3.0.8";

  src = (
    finalAttrs.passthru.sources.${stdenv.system}
      or (throw "gk-cli ${finalAttrs.version} unsupported system: ${stdenv.system}")
  );

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 gk*/gk -t $out/bin/

    wrapProgram $out/bin/gk \
      --prefix PATH : "${lib.makeBinPath [ gitMinimal ]}"

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    create_config() {
      local TEMPORARY_HOME="$1"
      local CONFIG_FILE="$TEMPORARY_HOME/.gk/cli/gk_config.yaml"

      # Create empty config file to avoid "no config file found" at the beggining of generated completion
      mkdir --parents "$(dirname "$CONFIG_FILE")"
      touch "$CONFIG_FILE"
    }

    create_temporary_home() {
      local TEMPORARY_HOME="$(mktemp --directory)"

      create_config "$TEMPORARY_HOME"

      echo "$TEMPORARY_HOME"
    }

    # Use timeout because gk hangs instead of closing in the sandbox
    installShellCompletion --cmd gk \
      --bash <(HOME="$(create_temporary_home)" timeout 3 $out/bin/gk completion bash) \
      --fish <(HOME="$(create_temporary_home)" timeout 3 $out/bin/gk completion fish) \
      --zsh <(HOME="$(create_temporary_home)" timeout 3 $out/bin/gk completion zsh)
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    OUTPUT="$(
      HOME="$(mktemp --directory)" \
      timeout 3 `# Use timeout because gk hangs instead of closing in the sandbox` \
      $out/bin/gk setup \
      2>/dev/null \
      || true # Command fails because not logged in
    )"

    echo "$OUTPUT" | grep --quiet '^Git binary found: ✓$'
    echo "$OUTPUT" | grep --quiet '^CLI version: ${finalAttrs.version}$'
  '';

  passthru = {
    sources =
      let
        base_url = "https://github.com/gitkraken/gk-cli/releases/download/v${finalAttrs.version}/gk_${finalAttrs.version}_";
      in
      {
        aarch64-linux = fetchzip {
          url = "${base_url}linux_arm64.zip";
          hash = "sha256-vHGhlRHbk2/s3YmBdOPDbalEydpQVFkHiCkBVywa4N0=";
          stripRoot = false;
        };
        x86_32-linux = fetchzip {
          url = "${base_url}linux_386.zip";
          hash = "sha256-cv+MGnuUbmOkRXmEI35U1MIMBP+JUIvVvrNQWrSU7qQ=";
          stripRoot = false;
        };
        x86_64-linux = fetchzip {
          url = "${base_url}linux_amd64.zip";
          hash = "sha256-Q1Gd+N2KM9fRUCp1AYorA1z8cPHEQ77nqEYEu5x8xA4=";
          stripRoot = false;
        };
        aarch64-darwin = fetchzip {
          url = "${base_url}darwin_arm64.zip";
          hash = "sha256-gT2Rg+7Xe+4Hejdkameauv2noID/yOxe8kbeTuqAe8w=";
          stripRoot = false;
        };
        x86_64-darwin = fetchzip {
          url = "${base_url}darwin_amd64.zip";
          hash = "sha256-akrh77a/FNd6Q2M/rste+Vk72de8/XDJya/djH/emUY=";
          stripRoot = false;
        };
        aarch64-windows = fetchzip {
          url = "${base_url}windows_arm64.zip";
          hash = "sha256-HjPY4xXzrY0hMuSmjks4IFm8yNIS5v2dQv2kckscvEU=";
          stripRoot = false;
        };
        i686-windows = fetchzip {
          url = "${base_url}windows_386.zip";
          hash = "sha256-GexmqZ1se3ak6GX91SFP1ehC/jzRDkMna1lw2cximIA=";
          stripRoot = false;
        };
        x86_64-windows = fetchzip {
          url = "${base_url}windows_amd64.zip";
          hash = "sha256-rhiWHsUGyOmDn4xIJvHAofF5dRZsy1isy66427rTu1c=";
          stripRoot = false;
        };
      };
    updateScript = writeShellScript "update-gk-cli" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/gitkraken/gk-cli/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "gk-cli" "$NEW_VERSION" --ignore-same-version --source-key="passthru.sources.$platform"
      done
    '';
  };

  meta = {
    description = "CLI for Git collaboration across multiple repos and services";
    homepage = "https://www.gitkraken.com";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "gk";
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
