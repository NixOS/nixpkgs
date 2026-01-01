{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  git,
  jq,
<<<<<<< HEAD
  fzf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-worktree-switcher";
<<<<<<< HEAD
  version = "0.2.8";
=======
  version = "0.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mateusauler";
    repo = "git-worktree-switcher";
    tag = "${finalAttrs.version}-fork";
<<<<<<< HEAD
    hash = "sha256-OXUVIL4bIqqxnLLwdO0+8gxCDMqA4TPvjIc2i8BeBmw=";
  };

  buildInputs = [
    fzf
    git
    jq
=======
    hash = "sha256-vPnAXiizCU5nXce+aE2x2G5ei+7A+eBTUpxcGleSSa8=";
  };

  buildInputs = [
    jq
    git
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
        fzf
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
