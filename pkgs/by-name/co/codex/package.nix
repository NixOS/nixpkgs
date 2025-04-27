{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildNpmPackage rec {
  pname = "codex";
  version = "0.1.2504161510"; # from codex-cli/package.json

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "b0ccca555685b1534a0028cb7bfdcad8fe2e477a";
    hash = "sha256-WTnP6HZfrMjUoUZL635cngpfvvjrA2Zvm74T2627GwA=";
  };

  sourceRoot = "${src.name}/codex-cli";

  npmDepsHash = "sha256-riVXC7T9zgUBUazH5Wq7+MjU1FepLkp9kHLSq+ZVqbs=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "codex";
  };
}
