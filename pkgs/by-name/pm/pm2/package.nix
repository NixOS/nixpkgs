{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "pm2";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "Unitech";
    repo = "pm2";
    rev = "v${version}";
    hash = "sha256-thShqrnM5S3/IImEm+2vHVRLCsLJN5NGaSRYubtULW0=";
  };

  npmDepsHash = "sha256-6M8kwiCHaQzcFyUUx7Yax/dobATWXG0Di7enEzlO8YE=";

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
