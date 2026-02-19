{
  lib,
  tmux,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  runtimeShell,
  rustPlatform,
  skim,
  testers,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "skim";
  version = "2.0.2";

  outputs = [
    "out"
    "man"
    "vim"
  ];

  src = fetchFromGitHub {
    owner = "skim-rs";
    repo = "skim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V6ZIGPeGWTeNzOA9FDhARx63L3CVpUUpCILwIGg8NOY=";
  };

  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  cargoHash = "sha256-xtrqY8jBB43Dpj4nOr2b0FziRvPjtRpWevAM8FeHqwc=";

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [ tmux ];

  # frizbee requires nightly features
  env.RUSTC_BOOTSTRAP = 1;

  postBuild = ''
    cat <<SCRIPT > sk-share
    #! ${runtimeShell}
    # Run this script to find the skim shared folder where all the shell
    # integration scripts are living.
    echo $out/share/skim
    SCRIPT
  '';

  postInstall = ''
    installBin bin/sk-tmux
    install -D -m 444 plugin/skim.vim -t $vim/plugin
    install -D -m 444 shell/* -t $out/share/skim

    installBin sk-share
    installManPage $(find man -type f)
    installShellCompletion \
      --cmd sk \
      --bash shell/completion.bash \
      --fish shell/completion.fish \
      --zsh shell/completion.zsh
  '';

  useNextest = true;

  checkPhase =
    let
      skippedTests = [
        # Assertion Error: Insta: Code output doesn't match the expected snapshot
        "opt_replstr"
        "opt_with_nth_preview"
        "preview_offset_expr"
        "preview_navigation"
        "preview_offset_fixed"
        "preview_nul_char"
        "preview_nowrap"
        "preview_offset_fixed_and_expr"
        "preview_plus"
        "preview_preserve_quotes"
        "preview_pty_linux"
        "preview_wrap"
        "preview_window_down"
        "preview_window_left"
        "preview_window_up"
      ];
      filterExpr =
        "not ("
        + (builtins.concatStringsSep " or " (map (testName: "test(${testName})") skippedTests))
        + ")";
    in
    ''
      cargo nextest run --features test-utils --release --offline -E '${filterExpr}'
    '';

  passthru = {
    tests.version = testers.testVersion { package = skim; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line fuzzy finder written in Rust";
    homepage = "https://github.com/skim-rs/skim";
    changelog = "https://github.com/skim-rs/skim/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dywedir
      getchoo
      krovuxdev
    ];
    mainProgram = "sk";
  };
})
