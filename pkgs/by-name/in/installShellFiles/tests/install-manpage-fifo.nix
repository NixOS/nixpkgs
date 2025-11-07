{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-manpage-fifo"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    installManPage doc/*

    installManPage \
      --name foo.1 <(echo foo) \
      --name=bar.2 <(echo bar) \
      --name baz.3 <(echo baz)

    echo "foo" | cmp - $out/share/man/man1/foo.1
    echo "bar" | cmp - $out/share/man/man2/bar.2
    echo "baz" | cmp - $out/share/man/man3/baz.3
  ''
