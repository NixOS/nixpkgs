{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codediff-watcher";
  version = "0.37.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DDHcy9Qe6cl0sFNpvincrecWE/l7gsyHzkIDzizNWxA=";
  };

  cargoHash = "sha256-DTm0O28+qxQvEIa3MMyo+ieFwotV/A2GoJGemFlXYuw=";

  buildAndTestSubdir = "crates/watcher";

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native repository watcher for codediff.nvim";
    homepage = "https://github.com/esmuellert/codediff";
    license = lib.licenses.mit;
    mainProgram = "codediff-watcher";
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
