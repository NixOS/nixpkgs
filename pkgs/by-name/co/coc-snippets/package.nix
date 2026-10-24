{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-snippets";
  version = "3.4.10";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-snippets";
    tag = finalAttrs.version;
    hash = "sha256-MbjEp8tn3/45KhID7XvMcIBAXY2bgazu4JQirWcxkz4=";
  };

  npmDepsHash = "sha256-FOFCdlgW0Z34ixVCFbSJcl6dcPaGKiDpMmwF+M09hFU=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Snippets solution for coc.nvim";
    homepage = "https://github.com/neoclide/coc-snippets";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
