{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "16.2.3";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-kfirpw0wSOvq4C+O9gQpG4caqPCjRV47rAylKWmrfy4=";
  };

  npmDepsHash = "sha256-TW90pvkKEs5s2nvjkNyf5xQFmM6UueMSm8Ov03I3Nls=";

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
