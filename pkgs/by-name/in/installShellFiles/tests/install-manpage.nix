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
    mkdir -p doc
    echo foo > doc/foo.1
    echo bar > doc/bar.2.gz
    echo baz > doc/baz.3

    installManPage doc/*

    cmp doc/foo.1 $out/share/man/man1/foo.1
    cmp doc/bar.2.gz $out/share/man/man2/bar.2.gz
    cmp doc/baz.3 $out/share/man/man3/baz.3
  ''
