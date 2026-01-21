{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nodemon";
  version = "3.1.11";

  src = fetchFromGitHub {
    owner = "remy";
    repo = "nodemon";
    rev = "v${version}";
    hash = "sha256-nW3JTbz5fJ7nEqsB1ER7N3IiOu2GkUl5o9vZQZzkfxI=";
  };

  npmDepsHash = "sha256-cZHfaUWhKZYKRe4Foc2UymZ8hTPrGLzlcXe1gMsW1pU=";

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
