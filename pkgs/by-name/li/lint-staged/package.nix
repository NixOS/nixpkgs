{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "17.0.4";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-E0qShnB3zVz7oL+qPzPzLhEJ9PQDlMc4+L4vpD2enI8=";
  };

  npmDepsHash = "sha256-KYltk2z/1nTnaLroTErIu6eTyofvWp/wC1awEf0Ryg0=";

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
