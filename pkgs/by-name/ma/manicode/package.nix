{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "manicode";
  version = "1.0.101";

  src = fetchzip {
    url = "https://registry.npmjs.org/manicode/-/manicode-${version}.tgz";
    hash = "sha256-9cRKHF34Wt5tmvPuuChN2tEncfNDrXIIU+i6iHe6y+I=";
  };

  npmDepsHash = "sha256-b5BQBRO6MOqGKMwrFHyhauHm+gWsqKntkIJZw2jTFkA=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Use natural language to edit your codebase and run commands from your terminal faster";
    homepage = "https://manicode.ai";
    downloadPage = "https://www.npmjs.com/package/manicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "manicode";
  };
}
