{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runtimeShell,
  installShellFiles,
  bc,
  ncurses,
  testers,
  fzf,
}:

buildGoModule rec {
  pname = "fzf";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf";
    rev = "v${version}";
    hash = "sha256-P6jyKskc2jT6zMLAMxklN8e/630oWYT4bWim20IMKvo=";
  };

  vendorHash = "sha256-uFXHoseFOxGIGPiWxWfDl339vUv855VHYgSs9rnDyuI=";

  env.CGO_ENABLED = 0;

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version} -X main.revision=${src.rev}"
  ];

  # The vim plugin expects a relative path to the binary; patch it to abspath.
  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/fzf.vim

    if ! grep -q $out plugin/fzf.vim; then
        echo "Failed to replace vim base_dir path with $out"
        exit 1
    fi

    # fzf-tmux depends on bc
    substituteInPlace bin/fzf-tmux \
      --replace-fail "bc" "${lib.getExe bc}"
  '';

  postInstall = ''
    install bin/fzf-tmux $out/bin

    installManPage man/man1/fzf.1 man/man1/fzf-tmux.1

    install -D plugin/* -t $out/share/vim-plugins/fzf/plugin
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/fzf $out/share/nvim/site

    # Install shell integrations
    install -D shell/* -t $out/share/fzf/

    cat <<SCRIPT > $out/bin/fzf-share
    #!${runtimeShell}
    # Run this script to find the fzf shared folder where all the shell
    # integration scripts are living.
    echo $out/share/fzf
    SCRIPT
    chmod +x $out/bin/fzf-share
  '';

  passthru.tests.version = testers.testVersion {
    package = fzf;
  };

  meta = {
    changelog = "https://github.com/junegunn/fzf/blob/${src.rev}/CHANGELOG.md";
    description = "Command-line fuzzy finder written in Go";
    homepage = "https://github.com/junegunn/fzf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ma27
      zowoq
    ];
    mainProgram = "fzf";
    platforms = lib.platforms.unix;
  };
}
