{
  kernelPackages ? null,
  flavour,
  mkXfsFlags ? "",
}:
let
  preparationCode =
    {
      raid = ''
        machine.succeed("vgcreate test_vg /dev/vdb /dev/vdc")
        machine.succeed("lvcreate -L 512M --type raid0 test_vg -n test_lv")
      '';

      thinpool = ''
        machine.succeed("vgcreate test_vg /dev/vdb")
        machine.succeed("lvcreate -L 512M -T test_vg/test_thin_pool")
        machine.succeed("lvcreate -n test_lv -V 16G --thinpool test_thin_pool test_vg")
      '';

      vdo = ''
        machine.succeed("vgcreate test_vg /dev/vdb")
        machine.succeed("lvcreate --type vdo -n test_lv -L 6G -V 12G test_vg/vdo_pool_lv")
      '';
    }
    .${flavour};

  extraConfig =
    {
      raid = {
        boot.initrd.kernelModules = [
          "dm-raid"
          "raid0"
        ];
      };

      thinpool = {
        services.lvm = {
          boot.thin.enable = true;
          dmeventd.enable = true;
        };
      };

      vdo = {
        services.lvm = {
          boot.vdo.enable = true;
          dmeventd.enable = true;
        };
      };
    }
    .${flavour};

  extraCheck =
    {
      raid = ''
        "test_lv" in machine.succeed("lvs --select segtype=raid0")
      '';

      thinpool = ''
        "test_lv" in machine.succeed("lvs --select segtype=thin-pool")
      '';

      vdo = ''
        "test_lv" in machine.succeed("lvs --select segtype=vdo")
      '';
    }
    .${flavour};

in
import ../make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "lvm2-${flavour}-systemd-stage-1";
    meta.maintainers = lib.teams.helsinki-systems.members;

    nodes.machine =
      { pkgs, lib, ... }:
      {
        imports = [ extraConfig ];
        # Use systemd-boot
        virtualisation = {
          emptyDiskImages = [
            8192
            8192
          ];
          useBootLoader = true;
          useEFIBoot = true;
          # To boot off the LVM disk, we need to have a init script which comes from the Nix store.
          mountHostNixStore = true;
        };
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        environment.systemPackages = with pkgs; [ xfsprogs ];
        boot = {
          initrd.systemd = {
            enable = true;
            emergencyAccess = true;
          };
          initrd.services.lvm.enable = true;
          kernelPackages = lib.mkIf (kernelPackages != null) kernelPackages;
        };

        specialisation.boot-lvm.configuration.virtualisation.rootDevice = "/dev/test_vg/test_lv";
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      # Create a VG for the root
      ${preparationCode}
      machine.succeed("mkfs.xfs ${mkXfsFlags} /dev/test_vg/test_lv")
      machine.succeed("mkdir -p /mnt && mount /dev/test_vg/test_lv /mnt && echo hello > /mnt/test && umount /mnt")

      # Boot from LVM
      machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-lvm.conf")
      machine.succeed("sync")
      machine.crash()
      machine.wait_for_unit("multi-user.target")

      # Ensure we have successfully booted from LVM
      assert "(initrd)" in machine.succeed("systemd-analyze")  # booted with systemd in stage 1
      assert "/dev/mapper/test_vg-test_lv on / type ext4" in machine.succeed("mount")
      assert "hello" in machine.succeed("cat /test")
      ${extraCheck}
    '';
  }
)
