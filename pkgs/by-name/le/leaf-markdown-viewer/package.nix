{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leaf-markdown-viewer";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "RivoLink";
    repo = "leaf";
    tag = finalAttrs.version;
    hash = "sha256-WX9C4gWNPCHWFsHN4xFmShv6dJyYAVgr9xMw5JtoFHI=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-T6GH+Y9zBzSOp54shKtboydIZGPSsSKjuexQ3pQ1FqY=";

  nativeBuildInputs = [ installShellFiles ];

  # The config tests mutate the process-global LEAF_TAB_TITLE_LENGTH env var,
  # so they race against each other when cargo runs tests in parallel threads.
  dontUseCargoParallelTests = true;

  # `leaf --update` downloads a release asset and overwrites its own binary,
  # which cannot work from the read-only Nix store. Fail with a useful message
  # rather than a permission error.
  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "use update::run_update;" "" \
      --replace-fail "        run_update()?;" '        bail!("leaf was installed through Nix; update it with your Nix configuration instead of `leaf --update`");'
  '';

  # Shipped as static files in completions/, so no need to run the built
  # binary (keeps cross-compilation working).
  postInstall = ''
    installShellCompletion --cmd leaf \
      --bash completions/leaf.bash \
      --fish completions/leaf.fish \
      --nushell completions/leaf.nu \
      --zsh completions/leaf.zsh

    # installShellFiles has no PowerShell support and pwsh has no autoload
    # directory, so install by hand following the convention used by `tea`
    # and `openlist`. Users dot-source it from their profile.
    install -Dm644 completions/leaf.ps1 $out/share/powershell/leaf.Completion.ps1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal Markdown previewer with a GUI-like experience";
    homepage = "https://leaf.rivolink.mg";
    changelog = "https://github.com/RivoLink/leaf/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rhousand ];
    mainProgram = "leaf";
    platforms = lib.platforms.unix;
  };
})
