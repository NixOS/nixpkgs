{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "copilot-node-server";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "jfcherng";
    repo = "copilot-node-server";
    rev = "v${version}";
    hash = "sha256-yOqA2Xo4c7u0g6RQYt9joQk8mI9KE0xTAnLjln9atmg=";
  };

  npmDepsHash = "sha256-tbcNRQBbJjN1N5ENxCvPQbfteyxTbPpi35dYmeUc4A4=";

  postPatch = ''
    # Upstream doesn't provide any lock file so we provide our own:
    cp ${./package-lock.json} package-lock.json
  '';

  preInstall = ''
    # `npmInstallHook` requires a `node_modules/` folder but `npm
    # install` doesn't generate one because the project has no
    # dependencies:
    mkdir node_modules/
  '';

  forceEmptyCache = true;
  dontNpmBuild = true;

  meta = {
    description = "Copilot Node.js server";
    homepage = src.meta.homepage;
    license = lib.licenses.unfree; # I don't know: https://github.com/jfcherng/copilot-node-server/blob/main/LICENSE.md
    maintainers = with lib.maintainers; [ DamienCassou ];
    mainProgram = "copilot-node-server";
  };
}
