{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage (finalAttrs: {
  pname = "codebuff";
  version = "1.0.680";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${finalAttrs.version}.tgz";
    hash = "sha256-glsZk5q+Qd2NbMk/jIXklCHf9MSSqkMN67d7k1fuzlk=";
  };

  strictDeps = true;

  npmDepsHash = "sha256-+HZN4oal+Bn7uKfWrWd/eDRvuAPvRKlGO4ThFamNZCI=";

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
