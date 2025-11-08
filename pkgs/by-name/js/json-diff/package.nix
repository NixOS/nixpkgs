{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "json-diff";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "andreyvit";
    repo = "json-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b8CtttEmPUIuFba6yn0DhVsSM1RA8Jsl4+zGvk3EZ2s=";
  };

  npmDepsHash = "sha256-hpnmBD9fyudjc3dzxZ5L5mhkCfRbw7BaAHKGf76qVDU=";

  npmBuildScript = "test";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Structural diff for JSON files";
    homepage = "https://github.com/andreyvit/json-diff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "json-diff";
  };
})
