{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "manicode";
  version = "1.0.99";

  src = fetchzip {
    url = "https://registry.npmjs.org/manicode/-/manicode-${version}.tgz";
    hash = "sha256-LVTh8yOfP92zGSdxLpThC+U9E8cBjoL0+iMQOldNO8A=";
  };

  npmDepsHash = "sha256-MAm/FE8M6BBDZD5Fy2k6GcM5Qv35jNeUwHcemmbUj/A=";

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
