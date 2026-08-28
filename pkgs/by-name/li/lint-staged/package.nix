{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "17.4.1";

  src = fetchFromGitHub {
    owner = "lint-staged";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-Q8aChdTJTYN5UrYhmGvAz7vcIHTI/M1raCUS2ejd+SU=";
  };

  npmDepsHash = "sha256-hJVc7t9UateaSjmN6WIiRbmofvy++23x2oqAEf5Lofw=";

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
