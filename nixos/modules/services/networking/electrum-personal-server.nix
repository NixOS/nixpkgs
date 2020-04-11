{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.electrum-personal-server;
in {
  options = {

    services.electrum-personal-server = {
      enable = mkEnableOption "Enable the Electrum Personal Server as a systemd user service. Requires services.bitcoind";

      configFile = mkOption {
        type = types.str;
        default = "\$HOME/.config/electrum-personal-server/config.ini";
        example = "\$HOME/.config/electrum-personal-server/config.ini";
        description = "The user-specific configuration file path.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.electrum-personal-server;
        defaultText = "pkgs.electrum-personal-server";
        description = "The package providing the Electrum Personal Server.";
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = (config.services.bitcoind.enable == true);
        message = "To use Electrum Personal Server you must enable (and configure) Bitcoin Core with services.bitcoind.enable.";
      }
    ];

    systemd.user.services.electrum-personal-server = {
      description = "Electrum Personal Server";
      after = [ "bitcoind.service" "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 60;

        ExecStart = pkgs.writeScript "electrum-personal-server-execstart" ''
          #!/bin/sh
          ${cfg.package}/bin/electrum-personal-server ${cfg.configFile}
        '';

        # If the user doesn't have an Electrum Personal Server configuration,
        # don't bother running the service.
        ExecCondition = pkgs.writeScript "electrum-personal-server-execcondition" ''
          #!/bin/sh
          stat ${cfg.configFile}
        '';
      };
    };
  };
}
