{
  lib,
  rustPlatform,
  fetchFromGitLab,
  installShellFiles,
  pkg-config,
  python3,
  glib,
  gpgme,
  gtk3,
  stdenv,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prs";
  version = "0.5.4";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "prs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RWquV2apUazgGiwzTc0cMzKNItJOBZDSRMp13k+mhS0=";
  };

  cargoHash = "sha256-v5jZJQHXxMENJ5EbZjoI4sZ0EpCfVZOkOX442S1TReU=";

  nativeBuildInputs = [
    gpgme
    installShellFiles
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fix following error on darwin sandbox mode:
    # objc/notify.h:1:9: fatal error: could not build module 'Cocoa'
    writableTmpDirAsHomeHook
  ];

  cargoBuildFlags = [
    "--no-default-features"
    "--features=alias,backend-gpgme,clipboard,notify,select-fzf-bin,select-skim,tomb,totp"
  ];

  buildInputs = [
    glib
    gpgme
    gtk3
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd prs --$shell <($out/bin/prs internal completions $shell --stdout)
    done
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Secure, fast & convenient password manager CLI using GPG and git to sync";
    homepage = "https://gitlab.com/timvisee/prs";
    changelog = "https://gitlab.com/timvisee/prs/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      lgpl3Only # lib
      gpl3Only # everything else
    ];
    maintainers = with lib.maintainers; [ colemickens ];
    mainProgram = "prs";
  };
})
