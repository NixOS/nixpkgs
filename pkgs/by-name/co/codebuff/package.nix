{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage (finalAttrs: {
  pname = "codebuff";
  version = "1.0.638";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${finalAttrs.version}.tgz";
    hash = "sha256-Fyu2T3HGwKfECiw0zyRMH29iDAlrtpzvkoqswJiPl6Y=";
  };

  strictDeps = true;

  npmDepsHash = "sha256-Wb0FbeuzkKg3ljirUFX2ZHx1WS1K2lyuha9qWUncsiI=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Use natural language to edit your codebase and run commands from your terminal faster";
    homepage = "https://www.codebuff.com/";
    downloadPage = "https://www.npmjs.com/package/codebuff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "codebuff";
  };
})
