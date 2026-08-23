{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "deja-vu";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "vshulcz";
    repo = "deja-vu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h6YSQdbs5t49CeYbuI7QKtbrbVzYVZwtQDmN39bnINo=";
  };

  # No third-party dependencies: the module has no go.sum.
  vendorHash = null;

  subPackages = [ "cmd/deja" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd deja \
      --bash <($out/bin/deja completion bash) \
      --fish <($out/bin/deja completion fish) \
      --zsh <($out/bin/deja completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local searchable memory over the session histories coding agents already write";
    longDescription = ''
      deja indexes the session transcripts that coding agents write to disk —
      Claude Code, Codex, Cursor, opencode, Zed and others — including sessions
      from before it was installed, and searches them from the command line or
      through an MCP server the agents can call.

      Indexing and search are local: BM25 over the transcripts, no model and no
      embeddings, and credentials are redacted as the index is built.
    '';
    homepage = "https://github.com/vshulcz/deja-vu";
    changelog = "https://github.com/vshulcz/deja-vu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "deja";
  };
})
