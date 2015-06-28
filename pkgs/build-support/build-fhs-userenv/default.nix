{ writeText, writeScriptBin, stdenv, ruby } : { env, runScript } :

let
  name = env.pname;

  # Sandboxing script
  chroot-user = writeScriptBin "chroot-user" ''
    #! ${ruby}/bin/ruby
    ${builtins.readFile ./chroot-user.rb}
  '';

  init = writeText "init" ''
           [ -d "$1" ] && [ -r "$1" ] && cd "$1"
           shift
           exec "${runScript}" "$@"
         '';

in writeScriptBin name ''
  #! ${stdenv.shell}
  exec ${chroot-user}/bin/chroot-user ${env} bash -l ${init} "$(pwd)" "$@"
''
