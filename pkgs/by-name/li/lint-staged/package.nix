{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "17.6.0";

  src = fetchFromGitHub {
    owner = "lint-staged";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-dUZMViPdT0mjqAs5boofuJs8qSH0QPZVts7PRJrIa6k=";
  };

  npmDepsHash = "sha256-Utc/SknTuV706dNjVUwE6ad85O3Ud4HRVDBiKblgdw0=";

  dontNpmBuild = true;

  # Fixes `lint-staged --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  passthru.tests.version = testers.testVersion { package = lint-staged; };

  meta = {
    description = "Run linters on git staged files";
    longDescription = ''
      Run linters against staged git files and don't let 💩 slip into your code base!
    '';
    homepage = src.meta.homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DamienCassou ];
    mainProgram = "lint-staged";
  };
}
