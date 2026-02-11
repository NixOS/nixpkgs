{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-snippets";
  version = "3.4.7";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-snippets";
    tag = finalAttrs.version;
    hash = "sha256-xaExEsNy6uuYUTeyXaon4DAoRIF6OpIZis59oetR36c=";
  };

  npmDepsHash = "sha256-tRyFtfL3Jc+uajELVdJoDteY3lnq0Bx8UQTaz2HtbW0=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Snippets solution for coc.nvim";
    homepage = "https://github.com/neoclide/coc-snippets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
