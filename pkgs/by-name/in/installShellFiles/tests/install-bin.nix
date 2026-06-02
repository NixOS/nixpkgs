{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-bin"
  {
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    mkdir -p bin
    echo "echo hello za warudo" > bin/hello
    echo "echo amigo me gusta mucho" > bin/amigo

    installBin bin/*

    cmp bin/amigo $out/bin/amigo
    cmp bin/hello $out/bin/hello
  ''
