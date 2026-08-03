{
  lib,
  buildNpmPackage,
  fetchzip,
}:
buildNpmPackage (finalAttrs: {
  pname = "command-code";
  version = "1.9.0";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://registry.npmjs.org/command-code/-/command-code-${finalAttrs.version}.tgz";
    hash = "sha256-cqi8dvR0+WX3YQqvsXGpTy6KlwFwrKy5WfGO9EUynNc=";
  };

  # required until https://github.com/CommandCodeAI/command-code/issues/621 is fixed
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-W8e5NsBea4gIAkHJCH68TIJyaamEp+aCnVRmUGXwNdI=";

  dontNpmBuild = true;

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
