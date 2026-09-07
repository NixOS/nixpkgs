{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-manpage"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    echo foo > foo.1

    installManPage --name bar.1 foo.1

    cmp foo.1 $out/share/man/man1/bar.1
  ''
