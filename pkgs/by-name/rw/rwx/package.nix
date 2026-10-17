{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rwx";
  version = "1.0.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vncsmnl";
    repo = "rwx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-68940nad2tdWJF8mBGa55GVd/Jap0hu4Mq8zDUYE30Q=";
  };

  cargoHash = "sha256-WLB/TEeM8Z3E6AiC8dmJa1Wtax6tN7l72U3zcFSSLb4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive Unix file permissions and ownership TUI manager built in Rust with Ratatui and crossterm";
    homepage = "https://github.com/vncsmnl/rwx";
    changelog = "https://github.com/vncsmnl/rwx/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "rwx";
  };
})
