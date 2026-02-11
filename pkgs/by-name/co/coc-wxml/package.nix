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
  pname = "coc-wxml";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-wxml";
    tag = finalAttrs.version;
    hash = "sha256-6tI+rIgoKGafBSxbPumCquAahJVR3rUzJB4VWQR+qw0=";
  };

  # Fix yarn.lock file
  postPatch = ''
    substituteInPlace yarn.lock \
      --replace-fail "http://registry.npmjs.org" "https://registry.yarnpkg.com"
  '';

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src postPatch;
    hash = "sha256-s2doN+DeVJPIWe/vOuAH7cYl/S/v8S4yeTG6KIWKphA=";
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
    description = "Wxml extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-wxml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
