{ lib, buildNpmPackage, fetchFromGitHub, testers, lint-staged }:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "15.2.4";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = "lint-staged";
    rev = "v${version}";
    hash = "sha256-TGJz1jWXTNlTfHe1ed4jjR6SBlXriIAQJXQ4W6b7dQU=";
  };

  npmDepsHash = "sha256-2Lv7k41hWVHF5PGdpYlMoFAj/zDPuRg6ydXaWTpUR/g=";

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
