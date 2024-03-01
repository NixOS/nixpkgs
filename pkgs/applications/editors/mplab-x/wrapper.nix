{ lib, buildFHSEnv, execline, fuse-overlayfs, glibc, mplab-x-unwrapped, rsync
, systemdLibs, xorg, writeShellApplication }:

let
  fhsEnv = buildFHSEnv {
    name = "mplab-x-build-fhs-env";
    targetPkgs = pkgs: [
      glibc
      systemdLibs
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
    ];
  };

  stage2 = writeShellApplication {
    name = "mplab_ide-wrapper";
    runtimeInputs = [ execline fuse-overlayfs rsync ];
    text = ''
      # Make the rt directory, isolated from the host filesystem.
      rt="$XDG_RUNTIME_DIR/mplab-x"
      mkdir -p "$rt"
      mount -t tmpfs mplab-x-wrapper "$rt"

      # Make and populate the overlay subdirectory.
      mkdir -p "$rt/overlay/opt"
      rsync -rlp ${fhsEnv.fhsenv}/             "$rt/overlay/"
      rsync -rlp ${mplab-x-unwrapped}/etc/     "$rt/overlay/etc/"
      ln -s ${mplab-x-unwrapped}/opt/microchip "$rt/overlay/opt/microchip"

      # Make and mount (with FUSE) the newroot subdirectory.
      mkdir "$rt/newroot"
      fuse-overlayfs -o lowerdir=/:"$rt/overlay" "$rt/newroot"
      trap 'fusermount -zu "$rt/newroot"' EXIT

      # Set up /dev in the new rootfs.
      # mount -t tmpfs dev "$rt/newroot/dev"
      # touch "$rt/newroot/dev"/{full,null,random,tty,urandom,zero}
      # mkdir "$rt/newroot/dev/pts"
      # ln -s /proc/self/fd   "$rt/newroot/dev/fd"
      # ln -s pts/ptmx        "$rt/newroot/dev/ptmx"
      # ln -s /proc/self/fd/0 "$rt/newroot/dev/stdin"
      # ln -s /proc/self/fd/1 "$rt/newroot/dev/stdout"
      # ln -s /proc/self/fd/2 "$rt/newroot/dev/stderr"
      # mount -t devpts devpts     "$rt/newroot/dev/pts"
      # mount --rbind /dev/full    "$rt/newroot/dev/full"
      # mount --rbind /dev/null    "$rt/newroot/dev/null"
      # mount --rbind /dev/random  "$rt/newroot/dev/random"
      # mount --rbind /dev/tty     "$rt/newroot/dev/tty"
      # mount --rbind /dev/urandom "$rt/newroot/dev/urandom"
      # mount --rbind /dev/zero    "$rt/newroot/dev/zero"

      # Bind mount some subtrees we want to make mutable.
      mount --rbind /dev  "$rt/newroot/dev"
      mount --rbind /home "$rt/newroot/home"
      mount --rbind /proc "$rt/newroot/proc"
      mount --rbind /run  "$rt/newroot/run"
      mount --rbind /tmp  "$rt/newroot/tmp"
      mount --rbind /var  "$rt/newroot/var"

      # Chroot into the new rootfs and launch the IDE.
      export LD_LIBRARY_PATH="/lib''${LD_LIBRARY_PATH:+:}''${LD_LIBRARY_PATH:-}"
      chroot "$rt/newroot" execline-cd "$(pwd)" \
        ${mplab-x-unwrapped}/opt/microchip/mplabx/v6.20/mplab_platform/bin/mplab_ide
    '';

    inherit (mplab-x-unwrapped) meta;
  };

in writeShellApplication {
  name = "mplab_ide";
  text = ''
    unshare -mUr -- ${lib.getExe stage2} "$@"
  '';

  inherit (mplab-x-unwrapped) meta;
}
