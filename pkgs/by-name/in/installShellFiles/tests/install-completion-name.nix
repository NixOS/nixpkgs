{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-completion-name"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    echo foo > foo
    echo bar > bar
    echo baz > baz

    installShellCompletion --bash --name foobar.bash foo --zsh --name _foobar bar --fish baz

    cmp foo $out/share/bash-completion/completions/foobar.bash
    cmp bar $out/share/zsh/site-functions/_foobar
    cmp baz $out/share/fish/vendor_completions.d/baz
  ''
