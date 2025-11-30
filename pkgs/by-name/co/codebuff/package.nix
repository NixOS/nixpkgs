{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "codebuff";
  version = "1.0.512";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-RwvrASHienoqxrlNmY6gcGzMuMkhd9yZhp0DTLlmHHg=";
  };

  npmDepsHash = "sha256-wsRiRg9W5rw5xFCNNDw545yptupUmPse1Lu8jz3VMHA=";

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
