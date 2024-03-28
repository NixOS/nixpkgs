{ lib, buildFHSEnv, execline, fuse-overlayfs, glibc, mplab-x-unwrapped, rsync
, systemdLibs, writeShellApplication,

microchip-xc16 }:

let
  fhsEnv = buildFHSEnv {
    name = "mplab-x-fhs-env";
    targetPkgs = pkgs: [ glibc systemdLibs ];
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
      mkdir -p "$rt/overlay/opt/microchip"
      rsync -rlp ${fhsEnv.fhsenv}/             "$rt/overlay/"
      rsync -rlp ${mplab-x-unwrapped}/etc/     "$rt/overlay/etc/"
      ln -s "$HOME"                            "$rt/overlay/root"
      for f in ${mplab-x-unwrapped}/opt/microchip/*; do
        ln -s "$f" "$rt/overlay/opt/microchip/"
      done

      mkdir "$rt/overlay/opt/microchip/xc16"
      ln -s ${microchip-xc16} "$rt/overlay/opt/microchip/xc16/v${microchip-xc16.version}"

      # Make and mount (with FUSE) the newroot subdirectory.
      mkdir "$rt/newroot"
      fuse-overlayfs -o lowerdir="$rt/overlay":/ "$rt/newroot"
      trap 'fusermount -zu "$rt/newroot"' EXIT

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
        ${mplab-x-unwrapped}/opt/microchip/mplabx/v${mplab-x-unwrapped.version}/mplab_platform/bin/mplab_ide
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
