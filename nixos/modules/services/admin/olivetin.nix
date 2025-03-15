{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.olivetin;
in
{
  options = {
    services.olivetin = {
      enable = mkEnableOption (lib.mdDoc "OliveTin");

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/olivetin/";
        description = lib.mdDoc "The directory where Olivetin stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports in the firewall for the OliveTin web interface
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.olivetin;
        defaultText = literalExpression "pkgs.olivetin";
        description = lib.mdDoc ''
          OliveTin package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.olivetin = {
      description = "OliveTin";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/OliveTin -configdir='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 1340 ];
    };
  };
}

