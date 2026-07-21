{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  eslint_d,
  testers,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "15.0.2";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-Q1FW/DmUyHbTYcisQ0rp/XZXxkf3c6kO7jLM4b+kYHI=";
  };

  npmDepsHash = "sha256-XFFjrAEXtNFSuIN5yn2AQeurY3cpF0silSgmIA17Wog=";

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
