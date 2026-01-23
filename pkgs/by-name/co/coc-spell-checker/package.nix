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
  pname = "coc-spell-checker";
  version = "0-unstable-2022-12-19";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "coc-spell-checker";
    # Upstream has no tagged releases
    rev = "51c484169de17b5317e54f5cf06bcd3fb04477e7";
    hash = "sha256-WimL7rE+hYW8JoWDnsL3r1zAoEDZBDy6NY2i6Wblm8c=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-nMDcc8dP0L7vpIj6Q1HOJyFCkDZ+19/IdbONxBj1jq8=";
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
    description = "Basic spell checker that works well with camelCase code for (Neo)vim";
    homepage = "https://github.com/iamcco/coc-spell-checker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
