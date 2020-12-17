{ lib, callPackage, runCommandLocal, writeShellScriptBin, stdenv, coreutils, bubblewrap }:

args @ {
  name
, runScript ? "bash"
, extraInstallCommands ? ""
, meta ? {}
, passthru ? {}
, unshareUser ? true
, unshareIpc ? true
, unsharePid ? true
, unshareNet ? false
, unshareUts ? true
, unshareCgroup ? true
, ...
}:

with builtins;
let
  buildFHSEnv = callPackage ./env.nix { };

  env = buildFHSEnv (removeAttrs args [
    "runScript" "extraInstallCommands" "meta" "passthru"
    "unshareUser" "unshareCgroup" "unshareUts" "unshareNet" "unsharePid" "unshareIpc"
  ]);

  chrootenv = callPackage ./chrootenv {};

  etcBindFlags = let
    files = [
      # NixOS Compatibility
      "static"
      # Users, Groups, NSS
      "passwd"
      "group"
      "shadow"
      "hosts"
      "resolv.conf"
      "nsswitch.conf"
      # Sudo & Su
      "login.defs"
      "sudoers"
      "sudoers.d"
      # Time
      "localtime"
      "zoneinfo"
      # Other Core Stuff
      "machine-id"
      "os-release"
      # PAM
      "pam.d"
      # Fonts
      "fonts"
      # ALSA
      "asound.conf"
      # SSL
      "ssl/certs"
      "pki"
    ];
  in concatStringsSep "\n  "
  (map (file: "--ro-bind-try /etc/${file} /etc/${file}") files);

  init = run: writeShellScriptBin "${name}-init" ''
    source /etc/profile
    exec ${run} "$@"
  '';

  bwrapCmd = { initArgs ? "" }: ''
    blacklist=(/nix /dev /proc /etc)
    ro_mounts=()
    for i in ${env}/*; do
      path="/''${i##*/}"
      if [[ $path == '/etc' ]]; then
        continue
      fi
      ro_mounts+=(--ro-bind "$i" "$path")
      blacklist+=("$path")
    done

    if [[ -d ${env}/etc ]]; then
      for i in ${env}/etc/*; do
        path="/''${i##*/}"
        ro_mounts+=(--ro-bind "$i" "/etc$path")
      done
    fi

    declare -a auto_mounts
    # loop through all directories in the root
    for dir in /*; do
      # if it is a directory and it is not in the blacklist
      if [[ -d "$dir" ]] && [[ ! "''${blacklist[@]}" =~ "$dir" ]]; then
        # add it to the mount list
        auto_mounts+=(--bind "$dir" "$dir")
      fi
    done

    cmd=(
      ${bubblewrap}/bin/bwrap
      --dev-bind /dev /dev
      --proc /proc
      --chdir "$(pwd)"
      ${lib.optionalString unshareUser "--unshare-user"}
      ${lib.optionalString unshareIpc "--unshare-ipc"}
      ${lib.optionalString unsharePid "--unshare-pid"}
      ${lib.optionalString unshareNet "--unshare-net"}
      ${lib.optionalString unshareUts "--unshare-uts"}
      ${lib.optionalString unshareCgroup "--unshare-cgroup"}
      --die-with-parent
      --ro-bind /nix /nix
      ${etcBindFlags}
      "''${ro_mounts[@]}"
      "''${auto_mounts[@]}"
      ${init runScript}/bin/${name}-init ${initArgs}
    )
    exec "''${cmd[@]}"
  '';

  bin = writeShellScriptBin name (bwrapCmd { initArgs = ''"$@"''; });

in runCommandLocal name {
  inherit meta;

  passthru = passthru // {
    env = runCommandLocal "${name}-shell-env" {
      shellHook = bwrapCmd {};
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
