{ writeText, writeScriptBin, stdenv, ruby } : { env, runScript } :

let
  name = env.pname;

  # Sandboxing script
  chroot-user = writeScriptBin "chroot-user" ''
    #! ${ruby}/bin/ruby
    ${builtins.readFile ./chroot-user.rb}
  '';

  init = writeText "init" ''
           # Make /tmp directory
           mkdir -m 1777 /tmp

           # Expose sockets in /tmp
           for i in /host-tmp/.*-unix; do
             ln -s "$i" "/tmp/$(basename "$i")"
           done

           [ -d "$1" ] && [ -r "$1" ] && cd "$1"
           shift
           exec "${runScript}" "$@"
         '';

in writeScriptBin name ''
  #! ${stdenv.shell}
  exec ${chroot-user}/bin/chroot-user ${env} bash -l ${init} "$(pwd)" "$@"
''
