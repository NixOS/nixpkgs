{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prowlarr;
in
{
  options = {
    services.prowlarr = {
      enable = mkEnableOption (lib.mdDoc "Prowlarr");

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/private/prowlarr";
        description = lib.mdDoc "The directory where Prowlarr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Prowlarr web interface.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.prowlarr;
        defaultText = literalExpression "pkgs.prowlarr";
        description = lib.mdDoc ''
          Prowlarr package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.prowlarr = {
      description = "Prowlarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "prowlarr";
        BindPaths = [ cfg.dataDir ];
        ExecStart = "${cfg.package}/bin/Prowlarr -nobrowser -data=/var/lib/prowlarr";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 9696 ];
    };
  };
}
