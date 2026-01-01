{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "codebuff";
<<<<<<< HEAD
  version = "1.0.552";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-ATk5X+HdxTu4Pxq+gyUlpj9GNl7q9GK0jbhv9io7obQ=";
  };

  npmDepsHash = "sha256-DibaJSJyq6vMH4Vpu0oqQskJzVeikQuf5mVo9Xc3Pww=";
=======
  version = "1.0.512";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-RwvrASHienoqxrlNmY6gcGzMuMkhd9yZhp0DTLlmHHg=";
  };

  npmDepsHash = "sha256-wsRiRg9W5rw5xFCNNDw545yptupUmPse1Lu8jz3VMHA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
