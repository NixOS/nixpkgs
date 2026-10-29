{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  n8n,
}:

buildNpmPackage (finalAttrs: {
  pname = "n8n-nodes-carbonejs";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jreyesr";
    repo = "n8n-nodes-carbonejs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWErVquOEYCkoHIF6XSaDGzDbbkaNNoE70H/UvdZh6E=";
  };

  npmDepsHash = "sha256-h780VxvDMUC5tv3JhDxYOZGJ+j40BAhmo4pRczlByKs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (n8n.meta) platforms;
    description = "n8n community node for rendering Word templates using Carbone.js";
    homepage = "https://github.com/jreyesr/n8n-nodes-carbonejs";
    changelog = "https://github.com/jreyesr/n8n-nodes-carbonejs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sweenu ];
  };
})
