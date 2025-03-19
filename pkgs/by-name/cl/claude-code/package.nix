{
  lib,
  buildNpmPackage,
  fetchzip,
}:

buildNpmPackage rec {
  pname = "claude-code";
  version = "0.2.48";

  src = fetchzip {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    hash = "sha256-zocgUMHWAPhA9ebqfeVCMHuJ1QBX3q8Y/dDjsxKhPv4=";
  };

  npmDepsHash = "sha256-kwq08sKDZDH0eM5gAj+HllQkadDqgyNxMd2xmiTZvq8=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  AUTHORIZED = "1";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "An agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/claude-code";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "claude";
  };
}
