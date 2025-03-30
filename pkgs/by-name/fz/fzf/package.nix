{ lib
, buildGoModule
, fetchFromGitHub
, runtimeShell
, installShellFiles
, bc
, bash
, coreutils
, gawk
, gnused
, ncurses
, tmux
, testers
, fzf
}:

buildGoModule rec {
  pname = "fzf";
  version = "0.60.3";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = "fzf";
    rev = "v${version}";
    hash = "sha256-wa4tRPw+PMzGxvSm/uceQF1gZw2Kh5uattpgDCYoedA=";
  };

  vendorHash = "sha256-i4ofEI4K6Pypf5KJi/OW6e/vhnCHUArMHnZKrvQ8eww=";

  env.CGO_ENABLED = 0;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ bash ncurses ];

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

    sed -i \
      -e "s/fzf-tmux/FZF-TMUX/g" \
      -e "s/ (requires tmux 3.2 or above)//" \
      -e "s|fzf=.*|fzf=$out/bin/fzf|" \
      -e "/fzf executable not found/d" \
      bin/fzf-tmux
    substituteInPlace bin/fzf-tmux \
      --replace-fail awk ${lib.getExe gawk} \
      --replace-fail bc ${lib.getExe bc} \
      --replace-fail cat ${lib.getExe' coreutils "cat"} \
      --replace-fail "cut " "${lib.getExe' coreutils "cut"} " \
      --replace-fail mkfifo ${lib.getExe' coreutils "mkfifo"} \
      --replace-fail "sed " "${lib.getExe gnused} " \
      --replace-fail "tmux " "${lib.getExe tmux} " \
      --replace-fail tput ${lib.getExe' ncurses "tput"}
    sed -i "s/FZF-TMUX/fzf-tmux/g" bin/fzf-tmux
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
