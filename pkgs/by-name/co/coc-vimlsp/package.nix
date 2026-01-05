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
  pname = "coc-vimlsp";
  version = "0.8.0-unstable-2023-06-26";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "coc-vimlsp";
    rev = "9e88f053201b8b224a6849ce8f891f526e75a28b";
    hash = "sha256-U5nJRn0UZsGfyDR4gZN2E+TSWk0A7RXJqMRQMK3QV00=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-K5hC3YrzSxULt0SiX7r+b8uNWdnvqGe+/GBvZiFzW0c=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "vim-language-server extension for coc.nvim";
    homepage = "https://github.com/iamcco/coc-vimlsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
