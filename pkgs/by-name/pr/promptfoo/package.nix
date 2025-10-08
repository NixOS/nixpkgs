{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "promptfoo";
  version = "0.118.11";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    tag = finalAttrs.version;
    hash = "sha256-py85AvOnge5KAOwsCUVCgwVhbNMn6kqNpQ5w6KA60LM=";
  };

  npmDepsHash = "sha256-J/wVq10sgLFZiPuiXie3oi2I9uCycyRP/19AQdGLmF4=";

  # don't fetch playwright binary
  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  # cleanup dangling symlinks for workspaces
  preFixup = ''
    rm -rf $out/lib/node_modules/promptfoo/node_modules/app $out/lib/node_modules/promptfoo/node_modules/promptfoo-docs
  '';

  meta = {
    description = "Test your prompts, models, RAGs. Evaluate and compare LLM outputs, catch regressions, and improve prompt quality";
    mainProgram = "promptfoo";
    homepage = "https://www.promptfoo.dev/";
    changelog = "https://github.com/promptfoo/promptfoo/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nathanielbrough
      jk
    ];
  };
})
