{
  lib,
  buildNpmPackage,
  codex,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "codex-acp";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "codex-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oOByalquD4I4s+3JafMDYlQ3dGN1TAfq3sy6owSsv6M=";
  };

  npmDepsHash = "sha256-5dk7J0nDg4YWpiSnnY11JPWKgMgJn1Wi0KGAyhdc1Fk=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    # Use the source-built Nixpkgs package instead of npm's bundled Codex binaries.
    rm -r $out/lib/node_modules/@agentclientprotocol/codex-acp/node_modules/@openai/codex*
    rm $out/lib/node_modules/@agentclientprotocol/codex-acp/node_modules/.bin/codex
    wrapProgram $out/bin/codex-acp \
      --set-default CODEX_PATH ${lib.getExe codex}
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    npm test
    runHook postCheck
  '';

  postCheck = ''
    rm -r node_modules/.vite
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ACP adapter for Codex CLI";
    homepage = "https://github.com/agentclientprotocol/codex-acp";
    changelog = "https://github.com/agentclientprotocol/codex-acp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tpansino ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "codex-acp";
  };
})
