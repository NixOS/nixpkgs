{ nixos ? ./..
, nixpkgs ? /etc/nixos/nixpkgs
, system ? builtins.currentSystem
}:

with import ../lib/build-vms.nix { inherit nixos nixpkgs system; };

rec {
  name = "check-filesystems";

  nodes = {
    share = {pkgs, config, ...}: {
      services.nfs.server.enable = true;
      services.nfs.server.exports = ''
        /repos1 192.168.1.0/255.255.255.0(rw,no_root_squash)
        /repos2 192.168.1.0/255.255.255.0(rw,no_root_squash)
      '';
      services.nfs.server.createMountPoints = true;

      jobs.checkable = {
        startOn = [
          config.jobs.nfs_kernel_exports.name
          config.jobs.nfs_kernel_nfsd.name
        ];
        respawn = true;
      };
    };

    fsCheck = {pkgs, config, ...}: {
      fileSystems =
        let
          repos1 = {
            mountPoint = "/repos1";
            autocreate = true;
            device = "share:/repos1";
            fsType = "nfs";
          };

          repos2 = {
            mountPoint = "/repos2";
            autocreate = true;
            device = "share:/repos2";
            fsType = "nfs";
          };
        in pkgs.lib.mkVMOverride [
          repos1
          repos1 # check remount
          repos2 # check after remount
        ];

      jobs.checkable = {
        startOn = "stopped ${config.jobs.filesystems.name}";
        respawn = true;
      };
    };
  };

  vms = buildVirtualNetwork { inherit nodes; };

  test = runTests vms
    ''
      startAll;

      $share->waitForUnit("checkable");
      $fsCheck->waitForUnit("checkable");

      # check repos1
      $fsCheck->succeed("test -d /repos1");
      $share->succeed("touch /repos1/test1");
      $fsCheck->succeed("test -e /repos1/test1");

      # check repos2 (check after remount)
      $fsCheck->succeed("test -d /repos2");
      $share->succeed("touch /repos2/test2");
      $fsCheck->succeed("test -e /repos2/test2");

      # check without network
      $share->block();
      $fsCheck->fail("test -e /repos1/test1");
      $fsCheck->fail("test -e /repos2/test2");
    '';
}
