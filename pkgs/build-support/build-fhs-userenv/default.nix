{ runCommand, writeText, writeScriptBin, stdenv, ruby } : { env, runScript ? "bash" } :

let
  name = env.pname;

  # Sandboxing script
  chroot-user = writeScriptBin "chroot-user" ''
    #! ${ruby}/bin/ruby
    ${builtins.readFile ./chroot-user.rb}
  '';

  init = run: writeText "${name}-init" ''
    # Make /tmp directory
    mkdir -m 1777 /tmp

    # Expose sockets in /tmp
    for i in /host-tmp/.*-unix; do
      ln -s "$i" "/tmp/$(basename "$i")"
    done

    [ -d "$1" ] && [ -r "$1" ] && cd "$1"
    shift
    exec ${run} "$@"
  '';

in runCommand name {
  passthru.env =
    runCommand "${name}-shell-env" {
      shellHook = ''
        exec ${chroot-user}/bin/chroot-user ${env} bash -l ${init "bash"} "$(pwd)"
      '';
    } ''
      echo >&2 ""
      echo >&2 "*** User chroot 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
      echo >&2 ""
      exit 1
    '';
} ''
  mkdir -p $out/bin
  cat <<EOF >$out/bin/${name}
  #! ${stdenv.shell}
  exec ${chroot-user}/bin/chroot-user ${env} bash -l ${init runScript} "\$(pwd)" "\$@"
  EOF
  chmod +x $out/bin/${name}
''
