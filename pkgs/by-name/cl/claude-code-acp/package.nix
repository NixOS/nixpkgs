{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pG4iO2jVuzrSg7UfmOd2/gxsRKXLni8AWzpFEqtfu1s=";
  };

  npmDepsHash = "sha256-AmQCjPBcTX+0HRpow8B+nBQ/uqrti6QmWqErX2FI9+Y=";

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
