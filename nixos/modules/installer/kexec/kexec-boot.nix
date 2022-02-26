# This module exposes a config.system.build.kexecBoot attribute,
# which returns a directory with kernel, initrd and a shell script
# running the necessary kexec commands.

# It's meant to be scp'ed to a machine with working ssh and kexec binary
# installed.

# This is useful for (cloud) providers where you can't boot a custom image, but
# get some Debian or Ubuntu installation.

{ pkgs
, modulesPath
, config
, ...
}:
{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  config = {
    system.build.kexecBoot =
      let
        kexecScript = pkgs.writeScript "kexec-boot" ''
          #!/usr/bin/env bash
          if ! kexec -v >/dev/null 2>&1; then
            echo "kexec not found: please install kexec-tools" 2>&1
            exit 1
          fi
          SCRIPT_DIR=$( cd -- "$( dirname -- "''${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
          kexec --load ''${SCRIPT_DIR}/bzImage \
            --initrd=''${SCRIPT_DIR}/initrd.gz \
            --command-line "init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}"
          kexec -e
        ''; in
      pkgs.linkFarm "kexec-tree" [
        {
          name = "initrd.gz";
          path = "${config.system.build.netbootRamdisk}/initrd";
        }
        {
          name = "bzImage";
          path = "${config.system.build.kernel}/bzImage";
        }
        {
          name = "kexec-boot";
          path = kexecScript;
        }
      ];
  };
}
