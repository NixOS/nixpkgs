{ runCommand, lib, writeText, writeScriptBin, stdenv, bash, ruby } :
{ env, runScript ? "${bash}/bin/bash", extraBindMounts ? [], extraInstallCommands ? "", importMeta ? {} } :

let
  name = env.pname;
  bash' = "${bash}/bin/bash";

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
  meta = importMeta;
  passthru.env =
    runCommand "${name}-shell-env" {
      shellHook = ''
        export CHROOTENV_EXTRA_BINDS="${lib.concatStringsSep ":" extraBindMounts}:$CHROOTENV_EXTRA_BINDS"
        exec ${chroot-user}/bin/chroot-user ${env} ${bash'} -l ${init bash'} "$(pwd)"
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
  export CHROOTENV_EXTRA_BINDS="${lib.concatStringsSep ":" extraBindMounts}:\$CHROOTENV_EXTRA_BINDS"
  exec ${chroot-user}/bin/chroot-user ${env} ${bash'} -l ${init runScript} "\$(pwd)" "\$@"
  EOF
  chmod +x $out/bin/${name}
  ${extraInstallCommands}
''
