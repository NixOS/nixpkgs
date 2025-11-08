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
  pname = "coc-emmet";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-emmet";
    tag = finalAttrs.version;
    hash = "sha256-0f9wSn7W+8Pxce7hbdfNpL33oykuVGNifNnSPPdhKb8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-8oo/XG9WxgKIbhfBWiGry+SZJdQIFe/T5i9S0hgjmp0=";
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
    description = "Emmet extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-emmet";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
