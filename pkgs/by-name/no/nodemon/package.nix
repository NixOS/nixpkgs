{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nodemon";
  version = "3.1.14";

  src = fetchFromGitHub {
    owner = "remy";
    repo = "nodemon";
    rev = "v${version}";
    hash = "sha256-Kk42VjCmbkAfYzZEh4njyA4fodjmeCxIDraAZ8Hsd4g=";
  };

  npmDepsHash = "sha256-XjbzoF83qhdvtKt22Onrm0hH+Bjh724Zm+qVoZsY/pM=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple monitor script for use during development of a Node.js app";
    mainProgram = "nodemon";
    homepage = "https://nodemon.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
