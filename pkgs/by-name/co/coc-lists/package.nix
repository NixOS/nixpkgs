{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-lists";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-lists";
    tag = finalAttrs.version;
    hash = "sha256-uyk16paheNusvm0lJB4kP4QILK23XzyignVYs5KPF4E=";
  };

  npmDepsHash = "sha256-flwCiHVJU6awpMMvFyXVQAiOKLy/WwjTQaMABNYbo8g=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Common lists for coc.nvim";
    homepage = "https://github.com/neoclide/coc-lists";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
