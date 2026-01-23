{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-completion-inference"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    echo foo > foo.bash
    echo bar > bar.zsh
    echo baz > baz.fish
    echo buzz > buzz.nu

    installShellCompletion foo.bash bar.zsh baz.fish buzz.nu

    cmp foo.bash $out/share/bash-completion/completions/foo.bash
    cmp bar.zsh $out/share/zsh/site-functions/_bar
    cmp baz.fish $out/share/fish/vendor_completions.d/baz.fish
    cmp buzz.nu $out/share/nushell/vendor/autoload/buzz.nu
  ''
