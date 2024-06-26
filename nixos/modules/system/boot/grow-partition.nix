# This module automatically grows the root partition.
# This allows an instance to be created with a bigger root filesystem
# than provided by the machine image.

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [
    (mkRenamedOptionModule
      [
        "virtualisation"
        "growPartition"
      ]
      [
        "boot"
        "growPartition"
      ]
    )
  ];

  options = {
    boot.growPartition = mkEnableOption "growing the root partition on boot";
  };

  config = mkIf config.boot.growPartition {
    assertions = [
      {
        assertion = !config.boot.initrd.systemd.repart.enable && !config.systemd.repart.enable;
        message = "systemd-repart already grows the root partition and thus you should not use boot.growPartition";
      }
    ];
    systemd.services.growpart = {
      wantedBy = [ "-.mount" ];
      after = [ "-.mount" ];
      before = [
        "systemd-growfs-root.service"
        "shutdown.target"
      ];
      conflicts = [ "shutdown.target" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutSec = "infinity";
        # growpart returns 1 if the partition is already grown
        SuccessExitStatus = "0 1";
      };

      script = ''
        rootDevice="${config.fileSystems."/".device}"
        rootDevice="$(readlink -f "$rootDevice")"
        parentDevice="$rootDevice"
        while [ "''${parentDevice%[0-9]}" != "''${parentDevice}" ]; do
          parentDevice="''${parentDevice%[0-9]}";
        done
        partNum="''${rootDevice#''${parentDevice}}"
        if [ "''${parentDevice%[0-9]p}" != "''${parentDevice}" ] && [ -b "''${parentDevice%p}" ]; then
          parentDevice="''${parentDevice%p}"
        fi
        "${pkgs.cloud-utils.guest}/bin/growpart" "$parentDevice" "$partNum"
      '';
    };
  };
}
