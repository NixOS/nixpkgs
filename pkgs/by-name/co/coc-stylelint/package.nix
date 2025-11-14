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
  pname = "coc-stylelint";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-stylelint";
    tag = finalAttrs.version;
    hash = "sha256-EurfiE1xeJhyH4Idb/hf/eItwmv75lan1csz0KJMBXs=";
  };

  # Fix yarn.lock file
  postPatch = ''
    substituteInPlace yarn.lock \
      --replace-fail "http://registry.npmjs.org" "https://registry.yarnpkg.com"
  '';

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src postPatch;
    hash = "sha256-rcHjbiMDrgCHweRMDlfcMvAJT4VULks44fbpctPpZps=";
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
    description = "Stylelint extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-stylelint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
