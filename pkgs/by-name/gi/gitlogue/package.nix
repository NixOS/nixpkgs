{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  libssh2,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlogue";
  version = "0.11.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "gitlogue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IXxHJjsH0BGwNVEmBXCUvuTCAszpOjPpdW+1l6pLfNA=";
  };

  cargoHash = "sha256-03LbaTAMmpOjDfzl+pXc0wvsZJIwEmRlHApQyUoVAkU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
    libssh2
  ];

  checkFlags = lib.forEach [
    # integration tests
    "default_playback_fails_only_after_ui_startup_without_tty"
    "default_playback_quits_cleanly_in_pseudo_tty"
    "default_playback_with_invalid_theme_fails_before_ui_startup"
    "diff_subcommand_reports_no_changes_for_clean_repo"
    "diff_subcommand_with_invalid_theme_fails_before_ui_startup"
    "diff_subcommand_with_staged_changes_fails_only_after_ui_startup_without_tty"
    "diff_subcommand_with_staged_changes_quits_cleanly_in_pseudo_tty"
  ] (test: "--skip=${test}");

  env = {
    OPENSSL_NO_VENDOR = 1;
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cinematic Git commit replay tool for the terminal";
    longDescription = ''
      A cinematic Git commit replay tool for the terminal, turning your Git history into a living, animated story.
    '';
    homepage = "https://github.com/unhappychoice/gitlogue";
    changelog = "https://github.com/unhappychoice/gitlogue/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "gitlogue";
  };
})
