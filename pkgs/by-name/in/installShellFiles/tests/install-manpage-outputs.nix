{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-manpage-outputs"
  {
    outputs = [
      "out"
      "man"
      "devman"
    ];
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    mkdir -p doc
    echo foo > doc/foo.1
    echo bar > doc/bar.3

    installManPage doc/*

    # assert they didn't go into $out
    [[ ! -f $out/share/man/man1/foo.1 && ! -f $out/share/man/man3/bar.3 ]]

    # foo.1 alone went into man
    cmp doc/foo.1 ''${!outputMan:?}/share/man/man1/foo.1
    [[ ! -f ''${!outputMan:?}/share/man/man3/bar.3 ]]

    # bar.3 alone went into devman
    cmp doc/bar.3 ''${!outputDevman:?}/share/man/man3/bar.3
    [[ ! -f ''${!outputDevman:?}/share/man/man1/foo.1 ]]

    touch $out
  ''
