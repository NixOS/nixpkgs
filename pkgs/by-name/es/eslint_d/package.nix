{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  eslint_d,
  testers,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-VrKtLtFAWLtpKE0HfTzPcWCx1o7Fhm8ClveWJ64hj4U=";
  };

  npmDepsHash = "sha256-O1Y0fLkwCrDoIUVeQBXV8HVq490IR5+WjXfs3qY6vrM=";

  dontNpmBuild = true;

  passthru.tests.version = testers.testVersion {
    package = eslint_d;
    version = src.rev;
  };

  meta = {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
