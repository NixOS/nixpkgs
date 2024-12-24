{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  eslint_d,
  testers,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "14.2.2";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-7VsbGudZlfrjU+x3a9OWxu9qDCiDUq8xez85qNj08xY=";
  };

  npmDepsHash = "sha256-u8kmHQ7UfCR446d+HbkGlK76Aki+KrOtBO6/a/VXoTg=";

  dontNpmBuild = true;

  passthru.tests.version = testers.testVersion {
    package = eslint_d;
    version = src.rev;
  };

  meta = with lib; {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
