{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "n8n-nodes-carbonejs";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jreyesr";
    repo = "n8n-nodes-carbonejs";
    tag = "v${version}";
    hash = "sha256-Dvl+Kc04i+hQ8rciT7n3oS4rtgke+HEqUszJnQa7UA0=";
  };

  npmDepsHash = "sha256-3VwejuSFGvJWNsitLKfVVpB8GnkTrrf/LLobNCpy8gU=";

  meta = {
    description = "n8n community node for rendering Word templates using Carbone.js";
    homepage = "https://github.com/jreyesr/n8n-nodes-carbonejs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sweenu ];
  };
}
