{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  autoPatchelfHook,
  versionCheckHook,
  runCommand,
  testers,
  grok-build,
}:
let
  version = "1.0.0";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  platform = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    aarch64-darwin = "macos-aarch64";
  };

  sourceData = lib.mapAttrs (
    system: upstreamPlatform:
    fetchurl {
      url = "https://x.ai/cli/grok-${version}-${upstreamPlatform}";
      hash =
        {
          x86_64-linux = "sha256-KNvJZ6WEPa4jdLaDTa26uVNU5oXH5cjcdQuSpOX8fD4=";
          aarch64-linux = "sha256-u3xREWVkoiGfakmFCBUGD0FpGKxAfx8rqCxTwLDUOD8=";
          aarch64-darwin = "sha256-E8f08LmrsAvzghYwLqS6sx8D4TVV41dmIOyh3lcqjSE=";
        }
        .${system};
    }
  ) platform;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "grok-build";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = sourceData.${stdenvNoCC.hostPlatform.system} or throwSystem;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isElf [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/grok"
    ln -s grok "$out/bin/agent"

    ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
      installShellCompletion --cmd grok \
        --bash <("$out/bin/grok" completions bash) \
        --fish <("$out/bin/grok" completions fish) \
        --zsh <("$out/bin/grok" completions zsh)
    ''}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  installCheckPhase = ''
    runHook preInstallCheck

    # ensure is a symlink
    test -L "$out/bin/agent"

    # ensure agent points at grok
    [ "$(readlink -f "$out/bin/agent")" = "$(readlink -f "$out/bin/grok")" ]

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line coding agent by xAI";
    homepage = "https://docs.x.ai/build/overview";
    downloadPage = "https://x.ai/cli/stable";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ crertel ];
    platforms = lib.attrNames sourceData;
    mainProgram = "grok";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
