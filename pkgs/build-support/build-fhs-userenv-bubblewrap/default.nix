{ lib, callPackage, runCommandLocal, writeShellScriptBin, glibc, pkgsi686Linux, coreutils, bubblewrap }:

let buildFHSEnv = callPackage ./env.nix { }; in

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
, dieWithParent ? true
, ...
}:

with builtins;
let
  buildFHSEnv = callPackage ./env.nix { };

  env = buildFHSEnv (removeAttrs args [
    "runScript" "extraInstallCommands" "meta" "passthru" "dieWithParent"
    "unshareUser" "unshareCgroup" "unshareUts" "unshareNet" "unsharePid" "unshareIpc"
  ]);

  etcBindFlags = let
    files = [
      # NixOS Compatibility
      "static"
      "nix" # mainly for nixUnstable users, but also for access to nix/netrc
      # Shells
      "bashrc"
      "zshenv"
      "zshrc"
      "zinputrc"
      "zprofile"
      # Users, Groups, NSS
      "passwd"
      "group"
      "shadow"
      "hosts"
      "resolv.conf"
      "nsswitch.conf"
      # User profiles
      "profiles"
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
      "alsa"
      "asound.conf"
      # SSL
      "ssl/certs"
      "ca-certificates"
      "pki"
    ];
  in concatStringsSep "\n  "
  (map (file: "--ro-bind-try $(${coreutils}/bin/readlink -f /etc/${file}) /etc/${file}") files);

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
    blacklist=(/nix /dev /proc /etc)
    ro_mounts=()
    symlinks=()
    for i in ${env}/*; do
      path="/''${i##*/}"
      if [[ $path == '/etc' ]]; then
        :
      elif [[ -L $i ]]; then
        symlinks+=(--symlink "$(${coreutils}/bin/readlink "$i")" "$path")
        blacklist+=("$path")
      else
        ro_mounts+=(--ro-bind "$i" "$path")
        blacklist+=("$path")
      fi
    done

    if [[ -d ${env}/etc ]]; then
      for i in ${env}/etc/*; do
        path="/''${i##*/}"
        # NOTE: we're binding /etc/fonts and /etc/ssl/certs from the host so we
        # don't want to override it with a path from the FHS environment.
        if [[ $path == '/fonts' || $path == '/ssl' ]]; then
          continue
        fi
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
      ${lib.optionalString dieWithParent "--die-with-parent"}
      --ro-bind /nix /nix
      # Our glibc will look for the cache in its own path in `/nix/store`.
      # As such, we need a cache to exist there, because pressure-vessel
      # depends on the existence of an ld cache. However, adding one
      # globally proved to be a bad idea (see #100655), the solution we
      # settled on being mounting one via bwrap.
      # Also, the cache needs to go to both 32 and 64 bit glibcs, for games
      # of both architectures to work.
      --tmpfs ${glibc}/etc \
      --symlink /etc/ld.so.conf ${glibc}/etc/ld.so.conf \
      --symlink /etc/ld.so.cache ${glibc}/etc/ld.so.cache \
      --ro-bind ${glibc}/etc/rpc ${glibc}/etc/rpc \
      --remount-ro ${glibc}/etc \
      --tmpfs ${pkgsi686Linux.glibc}/etc \
      --symlink /etc/ld.so.conf ${pkgsi686Linux.glibc}/etc/ld.so.conf \
      --symlink /etc/ld.so.cache ${pkgsi686Linux.glibc}/etc/ld.so.cache \
      --ro-bind ${pkgsi686Linux.glibc}/etc/rpc ${pkgsi686Linux.glibc}/etc/rpc \
      --remount-ro ${pkgsi686Linux.glibc}/etc \
      ${etcBindFlags}
      "''${ro_mounts[@]}"
      "''${symlinks[@]}"
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
