{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  eslint_d,
  testers,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "14.3.0";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-Mu3dSgRIC2L9IImKixJfaUsltlajY0cYdXOSikNQuPo=";
  };

  npmDepsHash = "sha256-nZ9q+Xmd8JLs+xYEO1TVbDEmQl2UwR9D9OWqVChNHhw=";

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
