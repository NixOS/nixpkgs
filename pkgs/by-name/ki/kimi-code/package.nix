{
  lib,
  stdenv,
  fd,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeBinaryWrapper,
  nix-update-script,
  nodejs-slim,
  pnpm_10,
  pnpmConfigHook,
  ripgrep,
  versionCheckHook,
}:

let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kimi-code";
  version = "2.3.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-code";
    tag = "@moonshot-ai/kimi-code@${finalAttrs.version}";
    hash = "sha256-/2fHOH4Asps3qnMvrj6emc8vplhFqEm4sKv3Y9qmWHM=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-UwQHeVFdkxu+b0krgari3WvAqP70VRgO9+NafmTZnjQ=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build:packages
    pnpm --filter @moonshot-ai/kimi-code run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # The bundle leaves its runtime dependencies (chokidar, qrcode and ws)
    # external, so ship them in a production-only node_modules next to it.
    pnpm config set --location=project injectWorkspacePackages true
    pnpm --filter=@moonshot-ai/kimi-code --offline --prod --no-optional --ignore-scripts \
      deploy "$TMPDIR/kimi-code"
    # Drop pnpm state files that hold timestamps and build paths
    rm --recursive "$TMPDIR/kimi-code/node_modules"/{.bin,.modules.yaml,.pnpm-workspace-state-v1.json}

    mkdir --parents "$out/lib/kimi-code"
    cp --recursive \
      apps/kimi-code/{dist*,package.json} "$TMPDIR/kimi-code/node_modules" \
      "$out/lib/kimi-code"
    makeWrapper ${lib.getExe nodejs-slim} \
      "$out/bin/${finalAttrs.meta.mainProgram}" \
      --add-flags "$out/lib/kimi-code/dist/main.mjs" \
      --suffix PATH : ${
        lib.makeBinPath [
          fd
          ripgrep
        ]
      } \
      --set KIMI_CODE_NO_AUTO_UPDATE 1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "@moonshot-ai/kimi-code@(.*)"
    ];
  };

  meta = {
    description = "AI coding agent that runs in your terminal";
    longDescription = ''
      Kimi Code CLI is an AI coding agent that runs in your terminal.
      It can read and edit code, run shell commands, search files,
      fetch web pages, and choose the next step based on the feedback
      it receives.  It works out of the box with Moonshot AI's Kimi
      models and can also be configured to use other compatible
      providers.
    '';
    homepage = "https://www.kimi.com/code";
    changelog = "https://github.com/MoonshotAI/kimi-code/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "kimi";
    inherit (nodejs-slim.meta) platforms;
  };
})
