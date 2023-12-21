{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.readarr;
in
{
  options = {
    services.readarr = {
      enable = mkEnableOption (lib.mdDoc "Readarr");

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/readarr/";
        description = lib.mdDoc "The directory where Readarr stores its data files.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.readarr;
        defaultText = literalExpression "pkgs.readarr";
        description = lib.mdDoc "The Readarr package to use";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports in the firewall for Readarr
        '';
      };

      user = mkOption {
        type = types.str;
        default = "readarr";
        description = lib.mdDoc ''
          User account under which Readarr runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "readarr";
        description = lib.mdDoc ''
          Group under which Readarr runs.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.readarr = {
      description = "Readarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Readarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8787 ];
    };

    users.users = mkIf (cfg.user == "readarr") {
      readarr = {
        description = "Readarr service";
        home = cfg.dataDir;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "readarr") {
      readarr = { };
    };
  };
}
