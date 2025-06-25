{
  lib,
  buildNpmPackage,
  fetchzip,
  nodejs_20,
}:

buildNpmPackage rec {
  pname = "gemini-cli";
  version = "0.1.1";

  nodejs = nodejs_20;

  src = fetchzip {
    url = "https://registry.npmjs.org/@google/gemini-cli/-/gemini-cli-${version}.tgz";
    hash = "sha256-ZKBiWzofqUC5sJN8FMrN4af74DYtksjyBZ4XZLbUrM0=";
  };

  npmDepsHash = "sha256-VWAjPZhsax4/nzircUwMMp7u0JNBpo+G5BYr+BHv9k8=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An open-source AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    downloadPage = "https://www.npmjs.com/package/@google/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      omarjatoi
    ];
    mainProgram = "gemini";
  };
}
