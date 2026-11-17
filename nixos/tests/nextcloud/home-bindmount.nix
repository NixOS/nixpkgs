{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { lib, ... }:
  {
    inherit name;
    meta.maintainers = lib.teams.nextcloud.members;

    imports = [ testBase ];

    nodes.nextcloud = { pkgs, ... }: {
      # Make sure that inside our tmpfs mount an actual directory for Nextcloud exists.
      boot.initrd.systemd.tmpfiles.settings."nextcloud"."/sysroot/mnt/nextcloud".d = { };

      boot.initrd.systemd.mounts = [
        # Create a mocked /mnt/nextcloud. Only a tmpfs here, but in reality this could e.g.
        # be the mount of a larger disk.
        {
          unitConfig.DefaultDependencies = "no";
          conflicts = [ "umount.target" ];
          wantedBy = [ "initrd.target" ];
          before = [ "systemd-tmpfiles-setup-sysroot.service" ];
          options = "x-initrd.mount";
          where = "/sysroot/mnt";
          what = "tmpfs";
          type = "tmpfs";
        }
        # Bind some directory to /var/lib/nextcloud, the place that the Nextcloud module expects
        # by default.
        {
          conflicts = [ "umount.target" ];
          wantedBy = [ "initrd.target" ];
          before = [ "systemd-tmpfiles-setup-sysroot.service" ];
          options = "x-initrd.mount,bind";
          where = "/sysroot/var/lib/nextcloud";
          what = "/sysroot/mnt/nextcloud";
          type = "none";
        }
      ];
      environment.systemPackages = [
        pkgs.util-linux
      ];
      services.nextcloud = {
        config.dbtype = "sqlite";
      };
    };

    test-helpers.init = ''
      import json
      mnts = json.loads(nextcloud.succeed("findmnt /var/lib/nextcloud -J"))["filesystems"]
      t.assertEqual(1, len(mnts))
      mnt = mnts[0]
      t.assertEqual("tmpfs[/nextcloud]", mnt["source"])
      t.assertEqual("/var/lib/nextcloud", mnt["target"])
    '';

    test-helpers.extraTests = ''
      nextcloud.succeed("test -d /mnt/nextcloud/data/root")
    '';
  }
)
