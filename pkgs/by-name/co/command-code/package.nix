{
  lib,
  buildNpmPackage,
  fetchzip,
}:
buildNpmPackage (finalAttrs: {
  pname = "command-code";
  version = "1.15.0";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://registry.npmjs.org/command-code/-/command-code-${finalAttrs.version}.tgz";
    hash = "sha256-WIFmU7glEE5IJlI/a0G+WDjTdfbh3VD3h298Tf9eB2w=";
  };

  # required until https://github.com/CommandCodeAI/command-code/issues/621 is fixed
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-9fXgFM4nEfFv5nBpUxfWO7jJsVkJ5aaiA9YGaReNTzI=";

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Coding agent that continuously learns your coding taste";
    homepage = "https://commandcode.ai/";
    downloadPage = "https://www.npmjs.com/package/command-code";
    changelog = "https://commandcode.ai/changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ malix ];
    mainProgram = "command-code";
  };
})
