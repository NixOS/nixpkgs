{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-lists";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-lists";
    tag = finalAttrs.version;
    hash = "sha256-SBqSBmAwklItqpNKjX3KaKlk1ve+siFfbtzeuCqiMxI=";
  };

  npmDepsHash = "sha256-c0sFu6eLrxTWq6iIWOke3jVjvntKkB3BjIZ9vpwz6eI=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Common lists for coc.nvim";
    homepage = "https://github.com/neoclide/coc-lists";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
