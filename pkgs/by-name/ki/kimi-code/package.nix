{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeBinaryWrapper,
  nix-update-script,
  nodejs-slim,
  pnpm_10,
  pnpmBuildHook,
  pnpmConfigHook,
  versionCheckHook,
}:

let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kimi-code";
  version = "0.38.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "MoonshotAI";
    repo = "kimi-code";
    tag = "@moonshot-ai/kimi-code@${finalAttrs.version}";
    hash = "sha256-PyFSEPOMvnvGhehZe4HvdSVGS1gGnhaG4K1UziThWSU=";
  };

  nativeBuildInputs = [
    nodejs-slim
    pnpm
    pnpmConfigHook
    pnpmBuildHook
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-P450+LKDYkRyk7OZ2mSOX0/RwtbivwR5ZksN8FM6+TU=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm -r --filter './packages/*' run build
    pnpm --filter @moonshot-ai/kimi-code run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents "$out/lib/kimi-code"
    cp --recursive \
      apps/kimi-code/{dist*,package.json} "$out/lib/kimi-code"
    makeWrapper ${lib.getExe nodejs-slim} \
      "$out/bin/${finalAttrs.meta.mainProgram}" \
      --add-flags "$out/lib/kimi-code/dist/main.mjs"

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
    description = "The Starting Point for Next-Gen Agents";
    longDescription = ''
      Kimi Code CLI is an AI coding agent that runs in your terminal —
      it can read and edit code, run shell commands, search files,
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
