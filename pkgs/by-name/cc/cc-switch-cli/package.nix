{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  stdenv,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cc-switch-cli";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "SaladDay";
    repo = "cc-switch-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JwtgT8cP+i7hsaB13o0PTDZJWvC3os1zWagMqmbffXk=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  cargoHash = "sha256-m70IR0IFUj8C48WcHgdCCtPwW/8KOxeDIqgG1bIcOpo=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cc-switch \
      --bash <($out/bin/cc-switch completions bash) \
      --fish <($out/bin/cc-switch completions fish) \
      --zsh <($out/bin/cc-switch completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # rusqlite uses the "bundled" feature which compiles SQLite from source,
  # so no system sqlite dependency is needed.

  checkFlags = [
    # Requires access to the system hostname, unavailable in the Nix build sandbox.
    "--skip=detect_system_device_name_returns_some"
    # Requires binding a network port, unavailable in the Nix build sandbox.
    "--skip=reloading_app_state_does_not_recover_an_active_takeover_session"
    # Invokes the install.sh script which downloads binaries from GitHub.
    "--skip=install_script"
  ];

  meta = {
    description = "Cross-platform CLI management tool for Claude Code, Codex, Gemini, and OpenCode";
    homepage = "https://github.com/SaladDay/cc-switch-cli";
    changelog = "https://github.com/SaladDay/cc-switch-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryango ];
    mainProgram = "cc-switch";
    platforms = lib.platforms.unix;
  };
})
