{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-eslint";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-eslint";
    tag = finalAttrs.version;
    hash = "sha256-sIXeqX+0L6g9ZNRn0hjQFs9KvCjtjZ0S2xnlM8D347g=";
  };

  npmDepsHash = "sha256-XonRSpc/j0QF2cSVX7qGEAcWW1QBvyP0KtzQXLZUDjU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Eslint extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-eslint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
