{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "pm2";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "Unitech";
    repo = "pm2";
    rev = "v${version}";
    hash = "sha256-LMBQ1+VyGjq76Qs5HtELSvEuml3XfzLBbvcuAFuJzw4=";
  };

  npmDepsHash = "sha256-hXP+rXXn0Ds81D2iLWVkgfFiFA3dDD5wrAoVivHaRHA=";

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
