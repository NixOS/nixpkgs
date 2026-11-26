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
  version = "1.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dcarrero";
    repo = "mboxshell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jtvpxAe5vv6HI/elY7+TbIXyD76valXtmOvUjD8pPEw=";
  };

  cargoHash = "sha256-aGNFurGAnwWVAUQ+/Tqfs4x6OxwVFnyCH3IN5R5a61U=";

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
