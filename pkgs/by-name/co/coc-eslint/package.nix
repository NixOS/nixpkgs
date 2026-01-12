{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-eslint";
  version = "3.0.15";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-eslint";
    tag = finalAttrs.version;
    hash = "sha256-41mUQpiFzBWMRoK7aQu0Gu4FBsYZdHbHPzrSMZR6RLQ=";
  };

  npmDepsHash = "sha256-g5gLAtBmwsHBCDHPfcVPETH7+djh0piJ6nJYSsy9GJQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Eslint extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-eslint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
