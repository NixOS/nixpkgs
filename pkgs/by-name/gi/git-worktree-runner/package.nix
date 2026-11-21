{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  bash,
  coreutils,
  findutils,
  gawk,
  git,
  gnugrep,
  gnused,
  perl,
  versionCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "git-worktree-runner";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "coderabbitai";
    repo = "git-worktree-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w15Todxvy6VyVE3EryOq4lAb0uUaLvunRjNW+xIdgi8=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [ bash ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/git-worktree-runner $out/bin
    cp -r bin lib adapters templates $out/share/git-worktree-runner/

    patchShebangs $out/share/git-worktree-runner/bin

    for prog in git-gtr gtr; do
      makeWrapper $out/share/git-worktree-runner/bin/$prog $out/bin/$prog \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            findutils
            gawk
            git
            gnugrep
            gnused
            perl # shasum, used to trust .gtrconfig hooks
          ]
        }
    done

    installShellCompletion \
      --cmd git-gtr \
        --bash completions/gtr.bash \
        --zsh  completions/_git-gtr \
        --fish completions/git-gtr.fish
    installShellCompletion --cmd gtr --bash completions/gtr.bash

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Bash-based Git worktree manager with editor and AI tool integration";
    homepage = "https://github.com/coderabbitai/git-worktree-runner";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "git-gtr";
    platforms = lib.platforms.unix;
  };
})
