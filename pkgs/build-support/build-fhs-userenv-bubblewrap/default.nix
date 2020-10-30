{ callPackage, runCommandLocal, writeShellScriptBin, stdenv, glibc, coreutils, bubblewrap }:

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
  in concatStringsSep " \\\n  "
  (map (file: "--ro-bind-try /etc/${file} /etc/${file}") files);

  # Create this on the fly instead of linking from /nix
  # The container might have to modify it and re-run ldconfig if there are
  # issues running some binary with LD_LIBRARY_PATH
  createLdConfCache = ''
    cat > /etc/ld.so.conf <<EOF
    /lib
    /lib/x86_64-linux-gnu
    /lib64
    /usr/lib
    /usr/lib/x86_64-linux-gnu
    /usr/lib64
    /lib/i386-linux-gnu
    /lib32
    /usr/lib/i386-linux-gnu
    /usr/lib32
    EOF
    ldconfig &> /dev/null
  '';
  init = run: writeShellScriptBin "${name}-init" ''
    source /etc/profile
    ${createLdConfCache}
    exec ${run} "$@"
  '';

  bwrapCmd = { initArgs ? "" }: ''
    blacklist="/nix /dev /proc /etc"
    ro_mounts=""
    for i in ${env}/*; do
      path="/''${i##*/}"
      if [[ $path == '/etc' ]]; then
        :
      elif [[ -L $i ]]; then
        symlinks="$symlinks --symlink $(readlink $i) $path"
        blacklist="$blacklist $path"
      else
        ro_mounts="$ro_mounts --ro-bind $i $path"
        blacklist="$blacklist $path"
      fi
    done

    if [[ -d ${env}/etc ]]; then
      for i in ${env}/etc/*; do
        path="/''${i##*/}"
        ro_mounts="$ro_mounts --ro-bind $i /etc$path"
      done
    fi

    declare -a auto_mounts
    # loop through all directories in the root
    for dir in /*; do
      # if it is a directory and it is not in the blacklist
      if [[ -d "$dir" ]] && grep -v "$dir" <<< "$blacklist" >/dev/null; then
        # add it to the mount list
        auto_mounts+=(--bind "$dir" "$dir")
      fi
    done

    exec ${bubblewrap}/bin/bwrap \
      --dev-bind /dev /dev \
      --proc /proc \
      --chdir "$(pwd)" \
      --unshare-all \
      --share-net \
      --die-with-parent \
      --ro-bind /nix /nix \
      --tmpfs ${glibc}/etc \
      --symlink /etc/ld.so.conf ${glibc}/etc/ld.so.conf \
      --symlink /etc/ld.so.cache ${glibc}/etc/ld.so.cache \
      --ro-bind ${glibc}/etc/rpc ${glibc}/etc/rpc \
      --remount-ro ${glibc}/etc \
      ${etcBindFlags} \
      $ro_mounts \
      $symlinks \
      "''${auto_mounts[@]}" \
      ${init runScript}/bin/${name}-init ${initArgs}
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
