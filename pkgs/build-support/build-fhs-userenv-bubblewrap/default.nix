{ callPackage, runCommandLocal, writeShellScriptBin, stdenv, coreutils, bubblewrap }:

let buildFHSEnv = callPackage ./env.nix { }; in

args @ {
  name,
  runScript ? "bash",
  extraInstallCommands ? "",
  meta ? {},
  passthru ? {},
  ...
}:

with builtins;
let
  env = buildFHSEnv (removeAttrs args [
    "runScript" "extraInstallCommands" "meta" "passthru"
  ]);

  chrootenv = callPackage ./chrootenv {};

  init = run: writeShellScriptBin "${name}-init" ''
    source /etc/profile
    exec ${run} "$@"
  '';

  bwrap_cmd = { init_args ? "" }: ''
    blacklist="/nix /dev /proc"
    ro_mounts=""
    for i in ${env}/*; do
      path="/''${i##*/}"
      ro_mounts="$ro_mounts --ro-bind $i $path"
      blacklist="$blacklist $path"
    done

    auto_mounts=""
    # loop through all directories in the root
    for dir in /*; do
      # if it is a directory and it is not in the blacklist
      if [[ -d "$dir" ]] && grep -v "$dir" <<< "$blacklist" >/dev/null; then
        # add it to the mount list
        auto_mounts="$auto_mounts --bind $dir $dir"
      fi
    done

    exec ${bubblewrap}/bin/bwrap \
      --dev /dev \
      --proc /proc \
      --chdir "$(pwd)" \
      --unshare-all \
      --share-net \
      --die-with-parent \
      --ro-bind /nix /nix \
      --ro-bind /etc /host-etc \
      $ro_mounts \
      $auto_mounts \
      ${init runScript}/bin/${name}-init ${init_args}
  '';

  bin = writeShellScriptBin name (bwrap_cmd { init_args = ''"$@"''; });

in runCommandLocal name {
  inherit meta;

  passthru = passthru // {
    env = runCommandLocal "${name}-shell-env" {
      shellHook = bwrap_cmd {};
    } ''
      echo >&2 ""
      echo >&2 "*** User chroot 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
      echo >&2 ""
      exit 1
    '';
  };
} ''
  mkdir -p $out/bin
  ln -s ${bin}/bin/${name} $out/bin/${name}
  ${extraInstallCommands}
''
