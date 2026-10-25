{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-json";
  version = "1.9.17";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-json";
    tag = finalAttrs.version;
    hash = "sha256-qku17wo96klHYBmTv9GbYVaAcq00OPkggm3zU7b0b2c=";
  };

  npmDepsHash = "sha256-2xhEb+fBFIJfTEaBI/2NM17gwxgYAdZS5dOPNZ8mke8=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON language extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-json";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
