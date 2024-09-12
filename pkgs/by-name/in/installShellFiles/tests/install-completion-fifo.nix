{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-completion-fifo"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    installShellCompletion \
      --bash --name foo.bash <(echo foo) \
      --zsh --name _foo <(echo bar) \
      --fish --name foo.fish <(echo baz)

    [[ $(<$out/share/bash-completion/completions/foo.bash) == foo ]] || { echo "foo.bash comparison failed"; exit 1; }
    [[ $(<$out/share/zsh/site-functions/_foo) == bar ]] || { echo "_foo comparison failed"; exit 1; }
    [[ $(<$out/share/fish/vendor_completions.d/foo.fish) == baz ]] || { echo "foo.fish comparison failed"; exit 1; }
  ''
