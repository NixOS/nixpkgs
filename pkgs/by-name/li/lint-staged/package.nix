{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "17.5.0";

  src = fetchFromGitHub {
    owner = "lint-staged";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-kRQDWJyyRFNxrdndOs2YYWetihwu+skTOCZ/dw5TzLs=";
  };

  npmDepsHash = "sha256-4yMbJFVgcVoo9AWEfJI+OfBoE4Y35rUnjFKuZ9g56/o=";

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
