{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "leetsolv";
  version = "1.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eannchen";
    repo = "leetsolv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZZ5TtrVUVWUTrGkp4p5k/aNT/XfCwJPsTjTUMcSz7sc=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
    "-X main.BuildTime=1970-01-01T00:00:00Z"
    "-X main.GitCommit=${finalAttrs.src.rev}"
  ];

  # needed for unit tests, also for version test
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spaced repetition CLI for DSA and LeetCode";
    homepage = "https://github.com/eannchen/leetsolv";
    changelog = "https://github.com/eannchen/leetsolv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "leetsolv";
  };
})
