{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "pm2";
  version = "6.0.14";

  src = fetchFromGitHub {
    owner = "Unitech";
    repo = "pm2";
    rev = "v${version}";
    hash = "sha256-s/ehFytny7UzXtw+0JhpZuWNAP4/Gl0tac7zK6eZCyM=";

    # Requested patch upstream: https://github.com/Unitech/pm2/pull/5985
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-sX3yQ/40rDc1G/ybegICmic7+GuaCsDLcM1X6OD0B1E=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/Unitech/pm2/blob/${src.rev}/CHANGELOG.md";
    description = "Node.js production process manager with a built-in load balancer";
    homepage = "https://github.com/Unitech/pm2";
    license = lib.licenses.agpl3Only;
    mainProgram = "pm2";
    maintainers = with lib.maintainers; [ jeremyschlatter ];
  };
}
