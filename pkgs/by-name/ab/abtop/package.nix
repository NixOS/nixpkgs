{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "abtop";
  version = "0.5.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "graykode";
    repo = "abtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LvN+q7JwmvtbroocoRBEug/J5OZTXwHEPAiaRkj16lM=";
  };

  cargoHash = "sha256-o5ZHURx+OAQkd7S0TzkLQG5ZsR5HMaqfl8sp639axbg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Like htop, but for AI coding agents";
    homepage = "https://github.com/graykode/abtop";
    changelog = "https://github.com/graykode/abtop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "abtop";
  };
})
