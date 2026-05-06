{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghdump";
  version = "0.1.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "ghdump";
    tag = finalAttrs.version;
    hash = "sha256-XOLXrffbymuPv544g66kwo1IKkEaK5/MBA1gsg+Cj2c=";
  };

  cargoHash = "sha256-kuXtBrMk1s5mDjMVL/BKV+8qRlJ/g0Svv07IQepcQE8=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/drupol/ghdump/releases/tag/${finalAttrs.version}";
    description = "Export GitHub issues, pull requests, and discussions through customizable templates";
    homepage = "https://github.com/drupol/ghdump";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "ghdump";
  };
})
