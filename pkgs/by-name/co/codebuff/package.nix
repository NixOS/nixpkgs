{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "codebuff";
  version = "1.0.615";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-4nO7OFr4NDwUo70wHKRJGiGRvKaqOXog0evn5kotxY8=";
  };

  npmDepsHash = "sha256-VoxULd9oOMvR8LLl6F6XuSM6nkqe+7mXgVFjWjeqdNE=";

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
