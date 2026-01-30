{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  n8n,
}:

buildNpmPackage (finalAttrs: {
  pname = "n8n-nodes-carbonejs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jreyesr";
    repo = "n8n-nodes-carbonejs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Dvl+Kc04i+hQ8rciT7n3oS4rtgke+HEqUszJnQa7UA0=";
  };

  npmDepsHash = "sha256-3VwejuSFGvJWNsitLKfVVpB8GnkTrrf/LLobNCpy8gU=";

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
