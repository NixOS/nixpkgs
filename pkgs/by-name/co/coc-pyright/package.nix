{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "1.1.371";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "d4cfda2f530622962a2a6e3ac1ddb2ad83ea2387";
    hash = "sha256-oNixIW63DhPn2LYJ5t/R4xcReZR3W6nqqFBnCUmo/Wo=";
  };

  npmDepsHash = "sha256-cTAt02RdQbKurP6H/JWwVp+VpoIysbFt9le9R69+DL4=";

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
