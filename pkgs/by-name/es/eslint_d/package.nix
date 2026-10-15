{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  eslint_d,
  testers,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "15.0.3";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-pcwU4WB1aIHYV50DMbuobsh3dQm+IJ6ByMUz4zvnwHE=";
  };

  npmDepsHash = "sha256-R1hv7sRZrDLDK05LvxyvuYCsugBM3c4pyZsqYlA7vd4=";

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
