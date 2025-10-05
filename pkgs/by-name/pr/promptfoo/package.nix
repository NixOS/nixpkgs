{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage (finalAttrs: {
  pname = "promptfoo";
  version = "0.117.4";

  src = fetchFromGitHub {
    owner = "promptfoo";
    repo = "promptfoo";
    tag = finalAttrs.version;
    hash = "sha256-0QF6sJ0SI6NA0yBdB7a4+ae8CcD0IiWYuFJNteZxvN8=";
  };

  # npm error code ENOTCACHED
  # npm error request to https://registry.npmjs.org/undici-types failed: cache mode is 'only-if-cached' but no cached response is available
  # deleted package-lock.json and ran `npm update` to get a new lock file
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  npmDepsHash = "sha256-sRTnIZqXbtiwk/jSTLIWLYwsNbR5nOL2d8Qsa3iF/Sg=";

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
