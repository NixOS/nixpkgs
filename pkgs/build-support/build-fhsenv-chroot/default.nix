{ lib, callPackage, runCommandLocal, writeScript, stdenv, coreutils }:

let buildFHSEnv = callPackage ./env.nix { }; in

args@{ name, version ? null, runScript ? "bash", nativeBuildInputs ? [], extraInstallCommands ? "", meta ? {}, passthru ? {}, ... }:

let
  env = buildFHSEnv (removeAttrs args [ "version" "runScript" "extraInstallCommands" "meta" "passthru" ]);

  chrootenv = callPackage ./chrootenv {};

  init = run: writeScript "${name}-init" ''
    #! ${stdenv.shell}
    for i in ${env}/* /host/*; do
      path="/''${i##*/}"
      [ -e "$path" ] || ${coreutils}/bin/ln -s "$i" "$path"
    done

    [ -d "$1" ] && [ -r "$1" ] && cd "$1"
    shift

    source /etc/profile
    exec ${run} "$@"
  '';

  versionStr = lib.optionalString (version != null) ("-" + version);

  nameAndVersion = name + versionStr;

in runCommandLocal nameAndVersion {
  inherit nativeBuildInputs meta;

  passthru = passthru // {
    env = runCommandLocal "${name}-shell-env" {
      shellHook = ''
        exec ${chrootenv}/bin/chrootenv ${init runScript} "$(pwd)"
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
  exec ${chrootenv}/bin/chrootenv ${init runScript} "\$(pwd)" "\$@"
  EOF
  chmod +x $out/bin/${name}
  ${extraInstallCommands}
''
