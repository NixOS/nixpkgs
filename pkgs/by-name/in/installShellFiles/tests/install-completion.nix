{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-completion"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    echo foo > foo
    echo bar > bar
    echo baz > baz
    echo qux > qux.zsh
    echo quux > quux
    echo quokka > quokka
    echo corge > corge.ps1

    installShellCompletion \
      --bash foo bar \
      --zsh baz qux.zsh \
      --fish quux \
      --nushell quokka \
      --powershell corge.ps1

    cmp foo $out/share/bash-completion/completions/foo
    cmp bar $out/share/bash-completion/completions/bar
    cmp baz $out/share/zsh/site-functions/_baz
    cmp qux.zsh $out/share/zsh/site-functions/_qux
    cmp quux $out/share/fish/vendor_completions.d/quux
    cmp quokka $out/share/nushell/vendor/autoload/quokka
    cmp corge.ps1 $out/share/powershell/corge.Completion.ps1
  ''
