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
      hash = "sha256-9fIPtzGKyZtv/fMGq+PIK4DtI4IRblAWNgWlabWVg98=";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      hash = "sha256-ZP3IRmspAPmP3y31FaXzvLrg9E1DDPtr7IF2ovBwh7s=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-rY9wB0KYG+uHWRYNu9eGGDrz12yX0VlePWQJnk8TySQ=";
    };
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-VuTJnenREQbD5r8xA0hk2490bLl8nq+UcK3PpkYdpm8=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "coderabbit-cli: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "coderabbit-cli";
  version = "0.9.0";

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
