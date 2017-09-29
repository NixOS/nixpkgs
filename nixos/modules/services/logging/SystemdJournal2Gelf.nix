{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.SystemdJournal2Gelf;
in

{ options = {
    services.SystemdJournal2Gelf = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable SystemdJournal2Gelf.
        '';
      };

      graylogServer = mkOption {
        type = types.string;
        example = "graylog2.example.com:11201";
        description = ''
          Host and port of your graylog2 input. This should be a GELF
          UDP input.
        '';
      };

      extraOptions = mkOption {
        type = types.string;
        default = "";
        description = ''
          Any extra flags to pass to SystemdJournal2Gelf. Note that
          these are basically <literal>journalctl</literal> flags.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.systemd-journal2gelf;
        description = ''
          SystemdJournal2Gelf package to use.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.SystemdJournal2Gelf = {
      description = "SystemdJournal2Gelf";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/SystemdJournal2Gelf ${cfg.graylogServer} --follow ${cfg.extraOptions}";
        Restart = "on-failure";
        RestartSec = "30";
      };
    };
  };
}