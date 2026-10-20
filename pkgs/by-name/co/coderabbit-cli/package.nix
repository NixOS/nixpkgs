{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  autoPatchelfHook,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  stdenv = stdenvNoCC;

  sources = {
    aarch64-darwin = {
      platform = "darwin-arm64";
      hash = "sha256-XmRgk7iWhTI0G+SRjjRGdbT6deAbojAsx9rSJS7tGOA=";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      hash = "sha256-3UuCMgFFvtOhul+E/zJ2fK0zxWUisex7YjjFfkAGBs0=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-OeelKnuIeYBRwIMwGcnP5I4DemXNu+mcW3paqpEqFE4=";
    };
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-7BVPV19XzW3TAJk4B3Im87gyoGBq1OdOJKgVJ2LWQko=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "coderabbit-cli: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "coderabbit-cli";
  version = "0.9.6";

  src = fetchurl {
    url = "https://cli.coderabbit.ai/releases/${finalAttrs.version}/coderabbit-${source.platform}.zip";
    inherit (source) hash;
  };

  # The archive holds a lone binary rather than a directory
  unpackCmd = "unzip $curSrc -d source";

  dontBuild = true;
  # Stripping removes the embedded application and leaves only the Bun runtime
  dontStrip = true;

  nativeBuildInputs = [
    installShellFiles
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 coderabbit $out/bin/coderabbit
    ln -s coderabbit $out/bin/cr

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # The binary must be patched before it can generate completions, but autoPatchelfHook only
    # runs during the fixup phase
    ${lib.optionalString stdenv.hostPlatform.isElf "autoPatchelf $out"}

    export HOME=$(mktemp -d)
    installShellCompletion --cmd coderabbit \
      --bash <($out/bin/coderabbit completion bash) \
      --fish <($out/bin/coderabbit completion fish) \
      --zsh <($out/bin/coderabbit completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CodeRabbit CLI for AI code reviews of local changes";
    homepage = "https://www.coderabbit.ai/cli";
    downloadPage = "https://docs.coderabbit.ai/cli";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames sources;
    maintainers = with lib.maintainers; [ lucperkins ];
    mainProgram = "coderabbit";
  };
})
