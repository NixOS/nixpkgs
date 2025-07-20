{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "codebuff";
  version = "1.0.436";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-eMoF+YrZttplzN+S9rEuHEBPSbGQnwWOFuZ+vVFrpik=";
  };

  npmDepsHash = "sha256-VTThvsHSiKSHmE7PYBUb5yZW2SKhLB7O5VjV8RhO9ZU=";

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
}
