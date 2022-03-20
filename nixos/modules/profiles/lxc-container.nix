{ config, pkgs, lib, ... }: {

  boot.isContainer = true;

  # TODO: build rootfs as squashfs for faster unpack
  system.build.tarball = pkgs.callPackage ../../lib/make-system-tarball.nix {
    extraArgs = "--owner=0";

    storeContents = [
      {
        object = config.system.build.toplevel;
        symlink = "none";
      }
    ];

    contents = [
      {
        source = config.system.build.toplevel + "/init";
        target = "/sbin/init";
      }
    ];

    extraCommands = "mkdir -p proc sys dev";
  };

  # Add the overrides from lxd distrobuilder
  systemd.extraConfig = ''
    [Service]
    ProtectProc=default
    ProtectControlGroups=no
    ProtectKernelTunables=no
  '';

  system.activationScripts.installInitScript = lib.mkForce ''
    ln -fs $systemConfig/init /sbin/init
  '';

  # We also have to do this currently for LXC.
  # Don't know why.
  # https://github.com/NixOS/nixpkgs/issues/157918
  systemd.suppressedSystemUnits = [
    "sys-kernel-debug.mount"
  ];

  systemd.services."container-getty@1".wantedBy = [ "getty.target" ];

}
