{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  makeWrapper,
  installShellFiles,
  writeShellScript,
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  gcsBucket = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
  manifestFile = ./manifest.json;
  manifestContents = if lib.pathExists manifestFile then lib.importJSON manifestFile else { };
  platforms = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };
  platform = platforms.${system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "claude-code";
  version = manifestContents.version or "unstable";

  src = fetchurl {
    url = "${gcsBucket}/${finalAttrs.version}/${platform}/claude";
    hash = manifestContents.hashes.${platform} or lib.fakeHash;
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ (lib.optional (!stdenvNoCC.isDarwin) autoPatchelfHook);

  installPhase = ''
    runHook preInstall

    installBin $src
    wrapProgram $out/bin/claude \
      --set DISABLE_AUTOUPDATER 1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = writeShellScript "update-claude-code" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq

    set -euo pipefail

    # https://claude.ai/install.sh
    version="$(curl -fsSL "${gcsBucket}/stable")"
    output="$(
      curl -fsSL "${gcsBucket}/$version/manifestContents.json" \
      | jq '{
        version: .version,
        hashes: .platforms | with_entries(
          select(.key | test("^(darwin|linux)-(x64|arm64)$"))
          | .value = "sha256:\(.value.checksum)"
        )
      }'
    )"
    echo "$output" > "${toString manifestFile}"
  '';

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    changelog = "https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      malo
      markus1189
      mirkolenz
      omarjatoi
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "claude";
    platforms = lib.attrNames platforms;
  };
})
