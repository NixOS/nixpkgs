{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "codebuff";
  version = "1.0.601";

  src = fetchzip {
    url = "https://registry.npmjs.org/codebuff/-/codebuff-${version}.tgz";
    hash = "sha256-iJW2f7x/Uh0Snl8h7OiQlAS4uQBgDT/l1QvzHUBpTS4=";
  };

  npmDepsHash = "sha256-z+22SK79cEDiNgPE4DPEHL8pFC6q2Q04KLIEDNQFKQQ=";

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
