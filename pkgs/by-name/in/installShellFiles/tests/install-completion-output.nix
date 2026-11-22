{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-completion-output"
  {
    outputs = [
      "out"
      "bin"
    ];
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    echo foo > foo

    installShellCompletion --bash foo

    # assert it didn't go into $out
    [[ ! -f $out/share/bash-completion/completions/foo ]]

    cmp foo ''${!outputBin:?}/share/bash-completion/completions/foo

    touch $out
  ''
