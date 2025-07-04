{ systemdStage1, ... }:

{
  name = "fsck";

  nodes.machine = {
    virtualisation.emptyDiskImages = [ 1 ];

    virtualisation.fileSystems = {
      "/mnt" = {
        device = "/dev/vdb";
        fsType = "ext4";
        autoFormat = true;
      };
    };

    boot.initrd.systemd.enable = systemdStage1;
  };

  testScript =
    { nodes, ... }:
    let
      rootDevice = nodes.machine.virtualisation.rootDevice;
    in
    ''
      machine.wait_for_unit("default.target")

      with subtest("root fs is fsckd"):
          machine.succeed("journalctl -b | grep '${
            if systemdStage1 then
              "fsck.*${builtins.baseNameOf rootDevice}.*clean"
            else
              "fsck.ext4.*${rootDevice}"
          }'")

      with subtest("mnt fs is fsckd"):
          machine.succeed("journalctl -b | grep 'fsck.*vdb.*clean'")
          machine.succeed(
              "grep 'Requires=systemd-fsck@dev-vdb.service' /run/systemd/generator/mnt.mount"
          )
          machine.succeed(
              "grep 'After=systemd-fsck@dev-vdb.service' /run/systemd/generator/mnt.mount"
          )
    '';
}
