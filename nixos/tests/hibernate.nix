# Test whether hibernation from partition works.

{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, systemdStage1 ? false
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  # System configuration of the installed system, which is used for the actual
  # hibernate testing.
  installedConfig = with pkgs.lib; {
    imports = [
      ../modules/testing/test-instrumentation.nix
      ../modules/profiles/qemu-guest.nix
      ../modules/profiles/minimal.nix
    ];

    hardware.enableAllFirmware = mkForce false;
    documentation.nixos.enable = false;
    boot.loader.grub.device = "/dev/vda";

    systemd.services.backdoor.conflicts = [ "sleep.target" ];

    powerManagement.resumeCommands = "systemctl --no-block restart backdoor.service";

    fileSystems."/" = {
      device = "/dev/vda2";
      fsType = "ext3";
    };
    swapDevices = mkOverride 0 [ { device = "/dev/vda1"; } ];
    boot.resumeDevice = mkIf systemdStage1 "/dev/vda1";
    boot.initrd.systemd = mkIf systemdStage1 {
      enable = true;
      emergencyAccess = true;
    };
  };
  installedSystem = (import ../lib/eval-config.nix {
    inherit system;
    modules = [ installedConfig ];
  }).config.system.build.toplevel;
in makeTest {
  name = "hibernate";

  nodes = {
    # System configuration used for installing the installedConfig from above.
    machine = { config, lib, pkgs, ... }: {
      imports = [
        ../modules/profiles/installation-device.nix
        ../modules/profiles/base.nix
        ./common/auto-format-root-device.nix
      ];

      nix.settings = {
        substituters = lib.mkForce [];
        hashed-mirrors = null;
        connect-timeout = 1;
      };

      virtualisation.diskSize = 8 * 1024;
      virtualisation.emptyDiskImages = [
        # Small root disk for installer
        512
      ];
      virtualisation.rootDevice = "/dev/vdb";
    };
  };

  # 9P doesn't support reconnection to virtio transport after a hibernation.
  # Therefore, machine just hangs on any Nix store access.
  # To avoid this, we install NixOS onto a temporary disk with everything we need
  # included into the store.

  testScript =
    ''
      def create_named_machine(name):
          machine = create_machine(
              {
                  "qemuFlags": "-cpu max ${
                    if system == "x86_64-linux" then "-m 1024"
                    else "-m 768 -enable-kvm -machine virt,gic-version=host"}",
                  "hdaInterface": "virtio",
                  "hda": "vm-state-machine/machine.qcow2",
                  "name": name,
              }
          )
          driver.machines.append(machine)
          return machine


      # Install NixOS
      machine.start()
      machine.succeed(
          # Partition /dev/vda
          "flock /dev/vda parted --script /dev/vda -- mklabel msdos"
          + " mkpart primary linux-swap 1M 1024M"
          + " mkpart primary ext2 1024M -1s",
          "udevadm settle",
          "mkfs.ext3 -L nixos /dev/vda2",
          "mount LABEL=nixos /mnt",
          "mkswap /dev/vda1 -L swap",
          # Install onto /mnt
          "nix-store --load-db < ${pkgs.closureInfo {rootPaths = [installedSystem];}}/registration",
          "nixos-install --root /mnt --system ${installedSystem} --no-root-passwd --no-channel-copy >&2",
      )
      machine.shutdown()

      # Start up
      hibernate = create_named_machine("hibernate")

      # Drop in file that checks if we un-hibernated properly (and not booted fresh)
      hibernate.succeed(
          "mkdir /run/test",
          "mount -t ramfs -o size=1m ramfs /run/test",
          "echo not persisted to disk > /run/test/suspended",
      )

      # Hibernate machine
      hibernate.execute("systemctl hibernate >&2 &", check_return=False)
      hibernate.wait_for_shutdown()

      # Restore machine from hibernation, validate our ramfs file is there.
      resume = create_named_machine("resume")
      resume.start()
      resume.succeed("grep 'not persisted to disk' /run/test/suspended")

      # Ensure we don't restore from hibernation when booting again
      resume.crash()
      resume.wait_for_unit("default.target")
      resume.fail("grep 'not persisted to disk' /run/test/suspended")
    '';

}
