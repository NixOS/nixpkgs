{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-router";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "musistudio";
    repo = "claude-code-router";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pw+MkOr/yN3Oq88YtpHqYHNQx3AZD/UcJZ1xdcX3DZ8=";
  };

  postPatch = ''
    substituteInPlace packages/cli/src/{cli.ts,utils/index.ts} \
      --replace-fail '"node"' '"${lib.getExe nodejs}"'
  '';

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit pnpm;
    inherit (finalAttrs) pname src;
    fetcherVersion = 3;
    hash = "sha256-8184F3ShoC6j7nov35CSZWz2dzPFQC7Bty1iTNs1qzc=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pnpm
  ];

  npmConfigHook = pnpmConfigHook;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/claude-code-router
    cp -r dist $out/lib/claude-code-router

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
