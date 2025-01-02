{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-6bC3irUyIppu7QVT3jGwMe+r/5WuHA0pLLH/gYORDOM=";
  };

  npmDepsHash = "sha256-exjK00MuzBsjlW34seaaAj8s0bPrzi7zBdJqQ0SuIWM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
