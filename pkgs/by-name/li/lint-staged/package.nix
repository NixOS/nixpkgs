{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "17.5.1";

  src = fetchFromGitHub {
    owner = "lint-staged";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-9fx514c0ZblPZaJmAGdmb2QbIodsaDS9MOoveUXwA2Q=";
  };

  npmDepsHash = "sha256-y8PSiJm3U9i5XaIkC06N/vjm/+OnqAHASRAMHlOVsGU=";

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
