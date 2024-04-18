{ lib
, alsa-lib
, at-spi2-atk
, buildFHSEnv
, cairo
, corefonts
, cups
, dbus
, execline
, fuse-overlayfs
, expat
, glib
, glibc
, gtk2
, gtk3
, gtk-engine-murrine
, libdrm
, libxkbcommon
, libusb1
, libxslt
, mesa
, mplab-x-unwrapped
, nspr
, nss
, pango
, rsync
, systemdLibs
, writeShellApplication
, xorg
# , microchip-xc8
, microchip-xc16
# , microchip-xc32
# , microchip-xc-dsc
}:

let
  fhsEnv = buildFHSEnv {
    name = "mplab-x-fhs-env";
    targetPkgs = pkgs: [
      alsa-lib
      at-spi2-atk
      cairo
      corefonts
      cups
      dbus
      expat
      glib
      glibc
      gtk2
      gtk3
      gtk-engine-murrine
      libdrm
      libxkbcommon
      libxslt
      libusb1
      mesa
      nspr
      nss
      pango
      systemdLibs
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
    ];
  };

  stage2 = writeShellApplication {
    name = "mplab_ide-wrapper";
    runtimeInputs = [ execline fuse-overlayfs rsync ];
    # mkdir "$rt/overlay/opt/microchip/xc8"
    # ln -s ${microchip-xc8} "$rt/overlay/opt/microchip/xc8/v${microchip-xc8.version}"
    # mkdir "$rt/overlay/opt/microchip/xc32"
    # ln -s ${microchip-xc32} "$rt/overlay/opt/microchip/xc32/v${microchip-xc32.version}"
    # mkdir "$rt/overlay/opt/microchip/xc-dsc"
    # ln -s ${microchip-xc-dsc} "$rt/overlay/opt/microchip/xc-dsc/v${microchip-xc-dsc.version}"
    text = ''
      # Make the rt directory, isolated from the host filesystem.
      rt="$XDG_RUNTIME_DIR/mplab-x"
      mkdir -p "$rt"
      mount -t tmpfs mplab-x-wrapper "$rt"

      # Make and populate the overlay subdirectory.
      mkdir -p "$rt/overlay/opt/microchip"
      rsync -rlp ${fhsEnv.fhsenv}/             "$rt/overlay/"
      rsync -rlp ${mplab-x-unwrapped}/etc/     "$rt/overlay/etc/"
      rsync -rlp ${mplab-x-unwrapped}/lib/udev "$rt/overlay/lib/udev/"
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

in
writeShellApplication {
  name = "mplab_ide";
  text = ''
    unshare -mUr -- ${lib.getExe stage2} "$@"
  '';

  inherit (mplab-x-unwrapped) meta;
}
