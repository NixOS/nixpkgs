{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-r-lsp";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-r-lsp";
    tag = finalAttrs.version;
    hash = "sha256-pjxnNzWOqlVWNNvEF9Yx1aQa4i3BpJoenuGQmY/k1QA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-BUg1ZhJn3pF2cQB6b1Fe0jsd9gi2ZyMhCt7SXtjvY54=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "R LSP client for coc.nvim";
    homepage = "https://github.com/neoclide/coc-r-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
