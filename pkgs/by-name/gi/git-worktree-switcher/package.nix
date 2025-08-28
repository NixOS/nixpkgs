{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  git,
  jq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-worktree-switcher";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mateusauler";
    repo = "git-worktree-switcher";
    tag = "${finalAttrs.version}-fork";
    hash = "sha256-N+bDsLEUM6FWhyliUav2n5hwMa5EEuVPoIK+Cja0DxA=";
  };

  buildInputs = [
    jq
    git
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  patches = [
    ./disable-update.patch # Disable update and auto update functionality
  ];

  installPhase = ''
    mkdir -p $out/bin

    cp wt $out/bin
    wrapProgram $out/bin/wt --prefix PATH : ${
      lib.makeBinPath [
        git
        jq
      ]
    }

    installShellCompletion --zsh completions/_wt_completion
    installShellCompletion --bash completions/wt_completion
    installShellCompletion --fish completions/wt.fish
  '';

  meta = {
    homepage = "https://github.com/mateusauler/git-worktree-switcher";
    description = "Switch between git worktrees with speed";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "wt";
    maintainers = with lib.maintainers; [
      jiriks74
      mateusauler
    ];
  };
})
