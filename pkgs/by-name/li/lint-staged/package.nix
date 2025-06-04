{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "16.1.0";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-dR0z/60CHDqCl9pEc9KQww1S5aSZ4XGsfNqxBSZe0Ig=";
  };

  npmDepsHash = "sha256-MznWvv61Z+8t+Nicj6yWlQqUHVx7AAtkDXu2L2E5dw8=";

  dontNpmBuild = true;

  # Fixes `lint-staged --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  passthru.tests.version = testers.testVersion { package = lint-staged; };

  meta = with lib; {
    description = "Run linters on git staged files";
    longDescription = ''
      Run linters against staged git files and don't let 💩 slip into your code base!
    '';
    homepage = src.meta.homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ DamienCassou ];
    mainProgram = "lint-staged";
  };
}
