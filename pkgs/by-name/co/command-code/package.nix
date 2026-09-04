{
  lib,
  buildNpmPackage,
  fetchzip,
  skipUpdates ? true,
}:
buildNpmPackage (finalAttrs: {
  pname = "command-code";
  version = "1.19.0";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://registry.npmjs.org/command-code/-/command-code-${finalAttrs.version}.tgz";
    hash = "sha256-ZkwzsfP/LSMx7VyB5c2dGrYYKNapgSQDxjtA5T89Ze0=";
  };

  # required until https://github.com/CommandCodeAI/command-code/issues/621 is fixed
  postPatch = ''
    cp ${./package.json} package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-/t3Jtko0WsWL7SiYW+Ml2QLn3MRwcFIPapK5vvL7Wwk=";

  dontNpmBuild = true;

  makeWrapperArgs = lib.optionals skipUpdates [
    "--set-default"
    "COMMANDCODE_SKIP_UPDATES"
    "1"
  ];

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
