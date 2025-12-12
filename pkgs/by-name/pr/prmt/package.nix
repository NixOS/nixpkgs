{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prmt";
  version = "0.1.7";

  src = fetchFromGitHub {
    repo = "prmt";
    owner = "3axap4eHko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CLSBthofkVdNE/ayecTRLtFDxtGesDuEGw1/Jutpu+c=";
  };

  cargoHash = "sha256-0TYjXpR3VyRdI+3ZIPnoaM1Mod0rXOinpByeOduKSdk=";

  # Fail to run in sandbox environment
  checkFlags = map (t: "--skip ${t}") [
    "modules::path::tests::relative_path_inside_home_renders_tilde"
    "modules::path::tests::relative_path_with_shared_prefix_is_not_tilde"
    "test_git_module"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ultra-fast, customizable shell prompt generator";
    homepage = "https://github.com/3axap4eHko/prmt";
    changelog = "https://github.com/3axap4eHko/prmt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "prmt";
  };
})
