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
  version = "0.2.82";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  platform = {
    x86_64-linux = "linux-x86_64";
    aarch64-linux = "linux-aarch64";
    x86_64-darwin = "macos-x86_64";
    aarch64-darwin = "macos-aarch64";
  };

  sourceData = lib.mapAttrs (
    system: upstreamPlatform:
    fetchurl {
      url = "https://x.ai/cli/grok-${version}-${upstreamPlatform}";
      hash =
        {
          x86_64-linux = "sha256-x0+vJ1FB4WVIgCQY6/EHY5R+uqAPJCe7gPAiq6Y2iP4=";
          aarch64-linux = "sha256-tHJ8YAeG1ko++xn3OmyLlRsHWzXW+nypUZoIlBFQelg=";
          x86_64-darwin = "sha256-wCiGbPt50wH/he2VJhdqFD2rUiUznZL0Hj8hUo4+s5Y=";
          aarch64-darwin = "sha256-HkyKeLBQ2TVj4g9iKkGjT46WuAV1sclYrT8JUxb+YYk=";
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
