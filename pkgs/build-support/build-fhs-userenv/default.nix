{ runCommand, lib, writeText, writeScriptBin, stdenv, ruby } :
{ env, runScript ? "bash", extraBindMounts ? [], extraInstallCommands ? "", meta ? {}, passthru ? {} } :

let
  name = env.pname;

  # Sandboxing script
  chroot-user = writeScriptBin "chroot-user" ''
    #! ${ruby}/bin/ruby
    ${builtins.readFile ./chroot-user.rb}
  '';

  init = run: writeText "${name}-init" ''
    source /etc/profile

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
  inherit meta;
  passthru = passthru // {
    env = runCommand "${name}-shell-env" {
      shellHook = ''
        export CHROOTENV_EXTRA_BINDS="${lib.concatStringsSep ":" extraBindMounts}:$CHROOTENV_EXTRA_BINDS"
        exec ${chroot-user}/bin/chroot-user ${env} bash -l ${init "bash"} "$(pwd)"
      '';
    } ''
      echo >&2 ""
      echo >&2 "*** User chroot 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
      echo >&2 ""
      exit 1
    '';
  };
} ''
  mkdir -p $out/bin
  cat <<EOF >$out/bin/${name}
  #! ${stdenv.shell}
  export CHROOTENV_EXTRA_BINDS="${lib.concatStringsSep ":" extraBindMounts}:\$CHROOTENV_EXTRA_BINDS"
  exec ${chroot-user}/bin/chroot-user ${env} bash ${init runScript} "\$(pwd)" "\$@"
  EOF
  chmod +x $out/bin/${name}
  ${extraInstallCommands}
''
