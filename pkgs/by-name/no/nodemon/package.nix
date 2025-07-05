{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "nodemon";
  version = "3.1.10";

  src = fetchFromGitHub {
    owner = "remy";
    repo = "nodemon";
    rev = "v${version}";
    hash = "sha256-wr/HNa+iqHhlE/Qp62d1EgcwA6hsv8CsJg9NLgEa15g=";
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
