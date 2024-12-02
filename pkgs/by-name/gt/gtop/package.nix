{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "gtop";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "aksakalli";
    repo = "gtop";
    rev = "v${version}";
    hash = "sha256-FKbaUV28d0JH9tmTSJBFYQrM5iensnIpcXUFFvXDMe4=";
  };

  npmDepsHash = "sha256-QKMLFalaOQjhgVkv8lIDnKyH7+GOqOKIl3zoLwrHIF4=";

  dontNpmBuild = true;

  meta = {
    description = "System monitoring dashboard for the terminal";
    homepage = "https://github.com/aksakalli/gtop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tfc ];
    mainProgram = "gtop";
  };
}
