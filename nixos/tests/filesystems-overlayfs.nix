{ lib, pkgs, ... }:

let
  initrdLowerdir = pkgs.runCommand "initrd-lowerdir" { } ''
    mkdir -p $out
    echo "initrd" > $out/initrd.txt
  '';
  initrdLowerdir2 = pkgs.runCommand "initrd-lowerdir-2" { } ''
    mkdir -p $out
    echo "initrd2" > $out/initrd2.txt
  '';
  userspaceLowerdir = pkgs.runCommand "userspace-lowerdir" { } ''
    mkdir -p $out
    echo "userspace" > $out/userspace.txt
  '';
  userspaceLowerdir2 = pkgs.runCommand "userspace-lowerdir-2" { } ''
    mkdir -p $out
    echo "userspace2" > $out/userspace2.txt
  '';
in
{

  name = "writable-overlays";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = { config, pkgs, ... }: {
    boot.initrd.systemd.enable = true;

    virtualisation.fileSystems = {
      "/initrd-overlay" = {
        overlay = {
          lowerdir = [ initrdLowerdir ];
          upperdir = "/.rw-initrd-overlay/upper";
          workdir = "/.rw-initrd-overlay/work";
        };
        neededForBoot = true;
      };
      "/userspace-overlay" = {
        overlay = {
          lowerdir = [ userspaceLowerdir ];
          upperdir = "/.rw-userspace-overlay/upper";
          workdir = "/.rw-userspace-overlay/work";
        };
      };
      "/ro-initrd-overlay" = {
        overlay.lowerdir = [
          initrdLowerdir
          initrdLowerdir2
        ];
        neededForBoot = true;
      };
      "/ro-userspace-overlay" = {
        overlay.lowerdir = [
          userspaceLowerdir
          userspaceLowerdir2
        ];
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("default.target")

    with subtest("Initrd overlay"):
      machine.wait_for_file("/initrd-overlay/initrd.txt", 5)
      machine.succeed("touch /initrd-overlay/writable.txt")
      machine.succeed("findmnt --kernel --types overlay /initrd-overlay")

    with subtest("Userspace overlay"):
      machine.wait_for_file("/userspace-overlay/userspace.txt", 5)
      machine.succeed("touch /userspace-overlay/writable.txt")
      machine.succeed("findmnt --kernel --types overlay /userspace-overlay")

    with subtest("Read only initrd overlay"):
      machine.wait_for_file("/ro-initrd-overlay/initrd.txt", 5)
      machine.wait_for_file("/ro-initrd-overlay/initrd2.txt", 5)
      machine.fail("touch /ro-initrd-overlay/not-writable.txt")
      machine.succeed("findmnt --kernel --types overlay /ro-initrd-overlay")

    with subtest("Read only userspace overlay"):
      machine.wait_for_file("/ro-userspace-overlay/userspace.txt", 5)
      machine.wait_for_file("/ro-userspace-overlay/userspace2.txt", 5)
      machine.fail("touch /ro-userspace-overlay/not-writable.txt")
      machine.succeed("findmnt --kernel --types overlay /ro-userspace-overlay")
  '';

}
