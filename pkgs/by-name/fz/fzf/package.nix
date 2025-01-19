{ lib
, buildGoModule
, fetchFromGitHub
, runtimeShell
, installShellFiles
, bc
, ncurses
, testers
, fzf
}:

buildGoModule rec {
  pname = "fzf";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf";
    rev = "v${version}";
    hash = "sha256-WEdCa6Krj+VicB1vxWzyY1rCHvmaL4t2njhhjq0Bppw=";
  };

  vendorHash = "sha256-utHQzXjtdnshUsYDQEQY2qoQGZsnfXXPj3A9VsDj0vQ=";

  env.CGO_ENABLED = 0;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  ldflags = [
    "-s" "-w" "-X main.version=${version} -X main.revision=${src.rev}"
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
    install -D shell/key-bindings.fish $out/share/fish/vendor_functions.d/fzf_key_bindings.fish
    mkdir -p $out/share/fish/vendor_conf.d
    cat << EOF > $out/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
      status is-interactive; or exit 0
      fzf_key_bindings
    EOF

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
    maintainers = with lib.maintainers; [ Br1ght0ne ma27 zowoq ];
    mainProgram = "fzf";
    platforms = lib.platforms.unix;
  };
}
