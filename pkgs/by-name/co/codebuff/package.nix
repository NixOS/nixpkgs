{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage (finalAttrs: {
  pname = "codebuff";
  version = "1.0.684";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${finalAttrs.version}.tgz";
    hash = "sha256-mWUIqBh5L39NC+fhPuAAxvcamo3uQPdCNvpniCNMJ8I=";
  };

  strictDeps = true;

  npmDepsHash = "sha256-JDuK1pipRKFG1wSEeAzJggHSdYqq753mR39Y+3MIwhM=";

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
