{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "codebuff";
  version = "1.0.630";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-4MXdEd1/wff6tpBg3ZWvDgK5l4ru4NBW3/Lnsl8a+MU=";
  };

  npmDepsHash = "sha256-s7+koNYCKeQ8dGEihm/3We8ZD0nhBXyrQ9oEzhohpL4=";

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
