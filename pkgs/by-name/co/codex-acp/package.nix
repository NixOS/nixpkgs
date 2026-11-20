{
  lib,
  buildNpmPackage,
  codex,
  fetchFromGitHub,
  jq,
  makeBinaryWrapper,
  nix-update-script,
  runCommand,
  stdenv,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "codex-acp";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "agentclientprotocol";
    repo = "codex-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e5EcyiQrayZ+FRUrVq0GC0XrSNn4BAM9lGVeroZyjIQ=";
  };

  npmDepsHash = "sha256-osqAy2cjtBbWNEZcMeVZxi2pVbCTReZY8Nd+KPJJRAo=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  env.CODEX_PATH = lib.getExe codex;

  postInstall = ''
    # Use the source-built Nixpkgs package instead of npm's bundled Codex binaries.
    rm -r $out/lib/node_modules/@agentclientprotocol/codex-acp/node_modules/@openai/codex*
    rm $out/lib/node_modules/@agentclientprotocol/codex-acp/node_modules/.bin/codex
    wrapProgram $out/bin/codex-acp \
      --set-default CODEX_PATH ${lib.getExe codex}
  '';

  # Codex's managed preferences sync fails for Darwin build users with /var/empty homes.
  # https://github.com/openai/codex/issues/50072
  doCheck = !stdenv.hostPlatform.isDarwin;

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

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--use-github-releases" ];
    };
    tests.e2e =
      runCommand "check-codex-acp"
        {
          nativeBuildInputs = [
            jq
            writableTmpDirAsHomeHook
          ];
        }
        ''
          coproc ACP { timeout 30s ${lib.getExe finalAttrs.finalPackage}; }
          acpPid=$ACP_PID
          acpInput=''${ACP[1]}

          printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1,"clientCapabilities":{}}}' >&"$acpInput"
          while IFS= read -r line; do
            printf '%s\n' "$line" >> "$out"
            if jq --exit-status '.id == 1' <<< "$line" > /dev/null; then
              break
            fi
          done <&"''${ACP[0]}"
          exec {acpInput}>&-
          wait "$acpPid"

          jq --exit-status --slurp '
            any(.[];
              .id == 1 and
              .result.protocolVersion == 1 and
              .result.agentInfo.name == "@agentclientprotocol/codex-acp"
            )
          ' "$out"
        '';
  };

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
