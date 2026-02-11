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
  pname = "coc-highlight";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-highlight";
    tag = finalAttrs.version;
    hash = "sha256-VksCqyB8b3Bk2BsnYFr6cJINqUzVY+px3TCiWzqFTzE=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-z9pJXGdUXNU8Bfhp7PUPZk7rCCAhnQpcmXUoHUaFAIU=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  yarnBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Highlight extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-highlight";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
