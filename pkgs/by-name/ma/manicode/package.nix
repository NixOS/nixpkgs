{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "manicode";
  version = "1.0.94";

  src = fetchzip {
    url = "https://registry.npmjs.org/manicode/-/manicode-${version}.tgz";
    hash = "sha256-mn3bxZashP4zgCO7pB9yqjZ7uLglTC+pa3ifxlIW4BY=";
  };

  npmDepsHash = "sha256-PnySdTtlgZ9J0qIegwgiDoGuqa7/KyUxUpiZ8yepuZI=";

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
