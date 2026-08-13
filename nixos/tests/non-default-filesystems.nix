{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;
{
  bind = makeTest {
    name = "non-default-filesystem-bind";

    nodes.machine =
      { ... }:
      {
        virtualisation.writableStore = false;

        virtualisation.fileSystems."/test-bind-dir/bind" = {
          device = "/";
          neededForBoot = true;
          fsType = "none";
          options = [ "bind" ];
        };

        virtualisation.fileSystems."/test-bind-file/bind" = {
          depends = [ "/nix/store" ];
          device = builtins.toFile "empty" "";
          neededForBoot = true;
          fsType = "none";
          options = [ "bind" ];
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
    '';
  };

  btrfs =
    let
      disk = "/dev/vda";
      partition = "/dev/disk/by-label/storage";
    in
    makeTest {
      name = "non-default-filesystems-btrfs";

      nodes.machine =
        { ... }:
        {
          virtualisation.rootDevice = disk;
          virtualisation.useDefaultFilesystems = false;

          systemd.repart.partitions."00-root" = {
            Type = "linux-generic";
            Format = "btrfs";
            Label = "storage";
            Subvolumes = [
              "/root"
              "/home"
            ];
            MakeDirectories = [
              "/root"
              "/home"
            ];
          };

          boot.initrd.supportedFilesystems = [ "btrfs" ];

          boot.initrd.systemd = {
            enable = true;
            repart = {
              enable = true;
              device = disk;
              empty = "allow";
            };
          };

          virtualisation.fileSystems = {
            "/" = {
              device = partition;
              fsType = "btrfs";
              options = [ "subvol=/root" ];
            };

            "/home" = {
              device = partition;
              fsType = "btrfs";
              options = [ "subvol=/home" ];
            };
          };
        };

      testScript = ''
        machine.wait_for_unit("multi-user.target")

        with subtest("BTRFS filesystems are mounted correctly"):
          realdev = machine.succeed("realpath '${partition}'")
          print(f"output of \"grep -E '{realdev}' /proc/mounts\":\n" + machine.execute(f"grep -E '{realdev}' /proc/mounts")[1])
          machine.succeed(f"grep -E '{realdev} / btrfs rw,.*subvolid=[0-9]+,subvol=/root 0 0' /proc/mounts")
          machine.succeed(f"grep -E '{realdev} /home btrfs rw,.*subvolid=[0-9]+,subvol=/home 0 0' /proc/mounts")
      '';
    };

  erofs =
    let
      fsImage = "/tmp/non-default-filesystem.img";
    in
    makeTest {
      name = "non-default-filesystems-erofs";

      meta.maintainers = with maintainers; [ nikstur ];

      nodes.machine = _: {
        virtualisation.qemu.drives = [
          {
            name = "non-default-filesystem";
            file = fsImage;
          }
        ];

        virtualisation.fileSystems."/non-default" = {
          device = "/dev/vdb";
          fsType = "erofs";
          neededForBoot = true;
        };
      };

      testScript = ''
        import subprocess
        import tempfile

        with tempfile.TemporaryDirectory() as tmp_dir:
          with open(f"{tmp_dir}/filesystem", "w") as f:
              f.write("erofs")

          subprocess.run([
            "${pkgs.erofs-utils}/bin/mkfs.erofs",
            "${fsImage}",
            tmp_dir,
          ])

        machine.start()
        machine.wait_for_unit("default.target")

        file_contents = machine.succeed("cat /non-default/filesystem")
        assert "erofs" in file_contents
      '';
    };

  squashfs =
    let
      fsImage = "/tmp/non-default-filesystem.img";
    in
    makeTest {
      name = "non-default-filesystems-squashfs";

      meta.maintainers = with maintainers; [ nikstur ];

      nodes.machine = {
        virtualisation.qemu.drives = [
          {
            name = "non-default-filesystem";
            file = fsImage;
            deviceExtraOpts.serial = "non-default";
          }
        ];

        virtualisation.fileSystems."/non-default" = {
          device = "/dev/disk/by-id/virtio-non-default";
          fsType = "squashfs";
          neededForBoot = true;
        };
      };

      testScript = ''
        import subprocess

        with open("filesystem", "w") as f:
          f.write("squashfs")

        subprocess.run([
          "${pkgs.squashfsTools}/bin/mksquashfs",
          "filesystem",
          "${fsImage}",
        ])

        assert "squashfs" in machine.succeed("cat /non-default/filesystem")
      '';
    };
}
