{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.openmesh.xnode.personaliser;
in {

  options.services.openmesh = {
    xnode.personaliser = {
      enable = mkEnableOption "Enable kernel command line based personalisation script for Xnode hardware platform integration";
      package = mkPackageOption pkgs "xnode-personaliser" { };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/xnode-personaliser";
        description = "State storage directory.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.xnode-personaliser = {
      description = "Openmesh Xnode Personalisation Script";
      wantedBy = [ "openmesh-xnode-admin.service" ];
      after = [ "network.target" ];
      wants = [ "network-online.target" ];
      before = [ "openmesh-xnode-admin.service" ];

      serviceConfig = {
        ExecStart = ''${cfg.package}/bin/xnode-personaliser ${cfg.stateDir}'';
        Type = "oneshot";
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "xnode-personaliser";
        StateDirectoryMode = "0775";
        RuntimeDirectory = "xnode-personaliser";
        RuntimeDirectoryMode = "0775";
        PrivateTmp = true;
        User="root";
        SystemCallArchitectures = "native";
      };
    };
  };
  meta.maintainers = with maintainers; [ j-openmesh ];
}
