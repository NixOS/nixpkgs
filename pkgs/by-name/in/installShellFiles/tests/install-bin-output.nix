{
  lib,
  installShellFiles,
  runCommandLocal,
}:

runCommandLocal "install-shell-files--install-bin-output"
  {
    outputs = [
      "out"
      "bin"
    ];
    nativeBuildInputs = [ installShellFiles ];
    meta.platforms = lib.platforms.all;
  }
  ''
    mkdir -p bin
    echo "echo hello za warudo" > bin/hello
    echo "echo amigo me gusta mucho" > bin/amigo

    installBin bin/*

    # assert it didn't go into $out
    [[ ! -f $out/bin/amigo ]]
    [[ ! -f $out/bin/hello ]]

    cmp bin/amigo ''${!outputBin}/bin/amigo
    cmp bin/hello ''${!outputBin}/bin/hello

    touch $out
  ''
