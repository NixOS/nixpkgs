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

  nodes.machine =
    { config, pkgs, ... }:
    {
      boot.initrd.systemd = {
        enable = true;
        # The goal is to test that the /initrd-no-base-dir-overlay file
        # system automatically gains a dependency on a mount unit for
        # its lower dir, but we also want that lower dir to have a
        # file in it. We can't just use a bind mount from a store
        # path, because the initrd's store gets deleted by switch-root
        # before the transition to stage 2, so files in it
        # disappear. And we can't use a tmpfs mount unit and add files
        # to it in a unit ordered in between the tmpfs and overlay,
        # because that would interfere with the very dependency we're
        # trying to test. So instead let's do both. Create a tmpfs to
        # store the file, and then a simple bind mount can be the
        # mount unit that we're testing for the overlay's dependency
        # on.
        services.create-lower = {
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          script = ''
            mkdir /tmpfs
            mount -t tmpfs tmpfs /tmpfs
            echo "initrd-no-base-dir" > /tmpfs/initrd-no-base-dir.txt
          '';
        };
        mounts = [
          {
            type = "bind";
            options = "bind";
            what = "/tmpfs";
            where = "/lower";
            requires = [ "create-lower.service" ];
            after = [ "create-lower.service" ];
          }
        ];
      };

      virtualisation.fileSystems = {
        "/initrd-overlay" = {
          overlay = {
            lowerdir = [ initrdLowerdir ];
            upperdir = "/.rw-initrd-overlay/upper";
            workdir = "/.rw-initrd-overlay/work";
          };
          neededForBoot = true;
        };
        "/initrd-no-base-dir-overlay" = {
          overlay = {
            lowerdir = [ "/lower" ];
            upperdir = "/run/upper";
            workdir = "/run/work";
            useStage1BaseDirectories = false;
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

    with subtest("Initrd overlay with non-sysroot dependencies"):
      machine.wait_for_file("/initrd-no-base-dir-overlay/initrd-no-base-dir.txt", 5)
      machine.succeed("touch /initrd-no-base-dir-overlay/writable.txt")
      machine.succeed("findmnt --kernel --types overlay /initrd-no-base-dir-overlay")

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
