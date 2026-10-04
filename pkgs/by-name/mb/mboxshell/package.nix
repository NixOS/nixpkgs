{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mboxshell";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dcarrero";
    repo = "mboxshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yLjlLIjGIoP26zR7ZcyWxy2si97ExWAhbpzMZ49i384=";
  };

  cargoHash = "sha256-cRs8fd5womtL9+IJZhhpa9LucS1PvtiASIakaaH1ym8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/mboxshell manpage > mboxshell.1
    installManPage mboxshell.1

    installShellCompletion --cmd mboxshell \
      --bash <($out/bin/mboxshell completions bash) \
      --fish <($out/bin/mboxshell completions fish) \
      --zsh <($out/bin/mboxshell completions zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast terminal viewer for MBOX files of any size";
    longDescription = ''
      mboxshell opens, searches and exports MBOX mailboxes (Gmail Takeout,
      Thunderbird, Apple Mail, Unix servers) from the terminal, streaming the
      file so even 50 GB+ archives open quickly. It never modifies the source
      mailbox. Includes a TUI with threading and a CLI for indexing, search,
      statistics, export (EML, CSV, HTML, text, mbox, Maildir), attachment
      extraction and merging.
    '';
    homepage = "https://github.com/dcarrero/mboxshell";
    changelog = "https://github.com/dcarrero/mboxshell/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dcarrero ];
    mainProgram = "mboxshell";
  };
})
