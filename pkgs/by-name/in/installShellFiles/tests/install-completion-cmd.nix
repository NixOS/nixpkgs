{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-completion-cmd"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    echo foo > foo.bash
    echo bar > bar.zsh
    echo baz > baz.fish
    echo qux > qux.fish
    echo buzz > buzz.nu

    installShellCompletion \
      --cmd foobar --bash foo.bash \
      --zsh bar.zsh \
      --fish baz.fish --name qux qux.fish \
      --nushell --cmd buzzbar buzz.nu

    cmp foo.bash $out/share/bash-completion/completions/foobar.bash
    cmp bar.zsh $out/share/zsh/site-functions/_foobar
    cmp baz.fish $out/share/fish/vendor_completions.d/foobar.fish
    cmp qux.fish $out/share/fish/vendor_completions.d/qux
    cmp buzz.nu $out/share/nushell/vendor/autoload/buzzbar.nu
  ''
