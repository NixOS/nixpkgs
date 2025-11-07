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
}:

rustPlatform.buildRustPackage rec {
  pname = "prs";
  version = "0.5.4";

  src = fetchFromGitLab {
    owner = "timvisee";
    repo = "prs";
    rev = "refs/tags/v${version}";
    hash = "sha256-RWquV2apUazgGiwzTc0cMzKNItJOBZDSRMp13k+mhS0=";
  };

  cargoHash = "sha256-v5jZJQHXxMENJ5EbZjoI4sZ0EpCfVZOkOX442S1TReU=";

  nativeBuildInputs = [
    gpgme
    installShellFiles
    pkg-config
    python3
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

  meta = {
    description = "Secure, fast & convenient password manager CLI using GPG and git to sync";
    homepage = "https://gitlab.com/timvisee/prs";
    changelog = "https://gitlab.com/timvisee/prs/-/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      lgpl3Only # lib
      gpl3Only # everything else
    ];
    maintainers = with lib.maintainers; [ colemickens ];
    mainProgram = "prs";
  };
}
