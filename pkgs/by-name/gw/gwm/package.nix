{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  perl,
  installShellFiles,
  makeWrapper,
  gitMinimal,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gwm";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "kbrdn1";
    repo = "gwm-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QQebYXTMfPZ2jwyVGf6orvHKPNYkyEJA3fhHOI6Pu94=";
  };

  cargoHash = "sha256-qSdcLGUkyBqjbNs71fLe35wVJtU3amaorMCDGfe8Sbs=";

  __structuredAttrs = true;

  # `git2` is built with the `vendored-libgit2` feature and `libz-sys` with
  # `static`, so libgit2 and zlib are compiled from source: cmake and perl are
  # all the C side needs, and there is no system libgit2/openssl to plumb.
  nativeBuildInputs = [
    cmake
    perl
    installShellFiles
    makeWrapper
  ];

  # The CLI suite drives the real binary against real repos: it needs `git` on
  # PATH (`gwm clean` gates on `git check-ignore`, and a missing git fails
  # safe, silently skipping the reclaim the test asserts), and a writable HOME
  # (the default `worktree.base` is `{home}/cc-worktree/{repo}`, which lands on
  # the read-only /homeless-shelter without the hook).
  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # gwm drives libgit2 for worktree operations but still shells out to `git`
  # for sync, rename, clean and the TUI previews, so it is a runtime dep that
  # no library-level dependency scan can infer.
  postInstall = ''
    wrapProgram $out/bin/gwm \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gwm \
      --bash <($out/bin/gwm completions bash) \
      --fish <($out/bin/gwm completions fish) \
      --zsh <($out/bin/gwm completions zsh)
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git worktree manager with a TUI and per-repo bootstrap";
    longDescription = ''
      gwm creates, lists and removes git worktrees from a per-repo `.gwm.toml`
      manifest, bootstrapping each new worktree by copying untracked files
      (such as `.env`), refusing to inherit dependency symlinks, and running
      post-create hooks. It ships both a CLI and a ratatui-based TUI.
    '';
    homepage = "https://github.com/kbrdn1/gwm-cli";
    # Per-version file, not the root CHANGELOG.md: upstream moves the entries
    # into `changelogs/<version>.md` when cutting the release, leaving the root
    # index empty at the tag.
    changelog = "https://github.com/kbrdn1/gwm-cli/blob/v${finalAttrs.version}/changelogs/${finalAttrs.version}.md";
    license = lib.licenses.mit;
    mainProgram = "gwm";
    maintainers = with lib.maintainers; [ kbrdn1 ];
    platforms = lib.platforms.unix;
  };
})
