{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage (finalAttrs: {
  pname = "codebuff";
  version = "1.0.682";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${finalAttrs.version}.tgz";
    hash = "sha256-s8cciXJp/fBeRMcZ2/ZJZmHfsBxz2R2ShnJw1KfXfnA=";
  };

  strictDeps = true;

  npmDepsHash = "sha256-h8HCtoUuVHE5QoIM9DCwzvp0evNvbfeUMKVxNSXjIis=";

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
