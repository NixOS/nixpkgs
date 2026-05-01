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
  version = "3.0.9";

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
    # Use timeout because gk hangs instead of closing in the sandbox
    installShellCompletion --cmd gk \
      --bash <(HOME="$(mktemp --directory)" timeout 3 $out/bin/gk completion bash) \
      --fish <(HOME="$(mktemp --directory)" timeout 3 $out/bin/gk completion fish) \
      --zsh <(HOME="$(mktemp --directory)" timeout 3 $out/bin/gk completion zsh)
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
          hash = "sha256-aYgHLpG4nX3Op0+j733jYbK4ZwVKkctMkDPweNTJWso=";
          stripRoot = false;
        };
        x86_32-linux = fetchzip {
          url = "${base_url}linux_386.zip";
          hash = "sha256-lVu25S7e6a/kHmiD5dxGAlHMQ5yN46+SdFpt8lghejM=";
          stripRoot = false;
        };
        x86_64-linux = fetchzip {
          url = "${base_url}linux_amd64.zip";
          hash = "sha256-/z2G//Zh8lTHkeJPahyld1EEXXhd/cgIvCojUmzFX8E=";
          stripRoot = false;
        };
        aarch64-darwin = fetchzip {
          url = "${base_url}darwin_arm64.zip";
          hash = "sha256-nDVehD0TTNTvhuDU8RB4lZiVcEJpB+l6EGkzckC7JuU=";
          stripRoot = false;
        };
        x86_64-darwin = fetchzip {
          url = "${base_url}darwin_amd64.zip";
          hash = "sha256-Lhuqb5592T6VcTMVmAdIDfGMXaS4dSu0wbQeHheXXk4=";
          stripRoot = false;
        };
        aarch64-windows = fetchzip {
          url = "${base_url}windows_arm64.zip";
          hash = "sha256-sXHeqR4AW/sRPp74PieXI1n4VGV94CnrcMF1ovAek8E=";
          stripRoot = false;
        };
        i686-windows = fetchzip {
          url = "${base_url}windows_386.zip";
          hash = "sha256-u6DyHoYIaExS2CHu20odDVJxzI4k9PpdFQf6UDPAzz0=";
          stripRoot = false;
        };
        x86_64-windows = fetchzip {
          url = "${base_url}windows_amd64.zip";
          hash = "sha256-nh+JPR95IWLm7CTrS8qK2dP3c4SH/zm1oIS5GNgxcyo=";
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
