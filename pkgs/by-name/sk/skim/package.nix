{
  lib,
  tmux,
  hexdump,
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
  version = "3.5.0";

  outputs = [
    "out"
    "man"
    "vim"
  ];

  src = fetchFromGitHub {
    owner = "skim-rs";
    repo = "skim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jm0mrxhjjggnfgp0mnau/LI0HwA8A9NkLIwm/ongI/s=";
  };

  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  cargoHash = "sha256-AU7Mkyjq3I6RmVlYz6A/AEgEyL0q1LwmagYT9v3j60U=";

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [
    tmux
    hexdump
  ];

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

  checkPhase = ''
    cargo nextest run --features test-utils --release --offline --lib --bins --examples --tests
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
