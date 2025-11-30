{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  git,
  makeWrapper,
  installShellFiles,
  testers,
  git-gtr,
}:

stdenvNoCC.mkDerivation rec {
  pname = "git-gtr";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "coderabbitai";
    repo = "git-worktree-runner";
    rev = "v${version}";
    hash = "sha256-TPd+5WtEZsR6x4/OPVkrIpW7SSDJpbZbvjYR8rzdZAs=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Install library and adapter files preserving directory structure
    # GTR_DIR expects lib/ and adapters/ subdirectories
    mkdir -p $out/lib/git-gtr
    cp -r lib $out/lib/git-gtr/
    cp -r adapters $out/lib/git-gtr/

    # Install gtr script with patched GTR_DIR
    mkdir -p $out/bin
    substitute bin/gtr $out/bin/gtr \
      --replace-fail ': "''${GTR_DIR:=$(resolve_script_dir)}"' ": \"\''${GTR_DIR:=$out/lib/git-gtr}\""
    chmod +x $out/bin/gtr

    # Install git-gtr wrapper with patched path
    substitute bin/git-gtr $out/bin/git-gtr \
      --replace-fail 'exec "$SCRIPT_DIR/gtr"' "exec $out/bin/gtr"
    chmod +x $out/bin/git-gtr

    # Patch shebangs
    patchShebangs $out/bin
    patchShebangs $out/lib/git-gtr

    # Wrap scripts to ensure git is in PATH
    wrapProgram $out/bin/gtr \
      --prefix PATH : ${lib.makeBinPath [ git ]}
    wrapProgram $out/bin/git-gtr \
      --prefix PATH : ${lib.makeBinPath [ git ]}

    # Install shell completions
    installShellCompletion --bash completions/gtr.bash
    installShellCompletion --zsh completions/_git-gtr
    installShellCompletion --fish completions/gtr.fish

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = git-gtr;
    command = "git-gtr --version";
    version = "git gtr version ${version}";
  };

  meta = {
    description = "Git worktree manager with editor and AI tool integration";
    longDescription = ''
      A portable, cross-platform CLI for managing git worktrees with ease.
      Automates per-branch worktree creation, configuration copying,
      dependency installation, and workspace setup for efficient parallel
      development with AI tools like Claude, Aider, and Codex.
    '';
    homepage = "https://github.com/coderabbitai/git-worktree-runner";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ luchiniatwork ];
    platforms = lib.platforms.unix;
    mainProgram = "git-gtr";
  };
}
