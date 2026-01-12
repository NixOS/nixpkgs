{
  buildNpmPackage,
  esbuild,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs_20,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  versionCheckHook,
}:
let
  nodejs = nodejs_20;
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };
  pnpm' = pnpm_10.override { inherit nodejs; };
in
buildNpmPackage' (finalAttrs: {
  pname = "claude-code-router";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "musistudio";
    repo = "claude-code-router";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Pw+MkOr/yN3Oq88YtpHqYHNQx3AZD/UcJZ1xdcX3DZ8=";
  };

  postPatch = ''
    substituteInPlace packages/cli/src/cli.ts \
      --replace-fail 'spawn("node"' 'spawn("${lib.getExe nodejs}"'
    substituteInPlace packages/cli/src/utils/index.ts \
      --replace-fail 'spawn("node"' 'spawn("${lib.getExe nodejs}"'
  '';

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src;
    pnpm = pnpm';
    fetcherVersion = 2;
    hash = "sha256-R2hEx77qiqAwQvTpUfKFp0NcmR9v2c4QE5K7iZ9bxEA=";
  };

  nativeBuildInputs = [
    esbuild
    makeBinaryWrapper
    pnpm'
  ];

  npmConfigHook = pnpmConfigHook;

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/claude-code-router/dist
    cp dist/cli.js $out/lib/claude-code-router/dist/
    cp dist/tiktoken_bg.wasm $out/lib/claude-code-router/dist/
    cp dist/index.html $out/lib/claude-code-router/dist/

    mkdir -p $out/bin
    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/ccr \
      --add-flags "$out/lib/claude-code-router/dist/cli.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  meta = {
    description = "Tool to route Claude Code requests to different models and customize any request";
    homepage = "https://github.com/musistudio/claude-code-router";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prince213
    ];
    mainProgram = "ccr";
  };
})
