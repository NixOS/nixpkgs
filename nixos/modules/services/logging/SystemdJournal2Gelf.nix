{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.SystemdJournal2Gelf;
in

{ options = {
    services.SystemdJournal2Gelf = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable SystemdJournal2Gelf.
        '';
      };

      graylogServer = mkOption {
        type = types.str;
        example = "graylog2.example.com:11201";
        description = lib.mdDoc ''
          Host and port of your graylog2 input. This should be a GELF
          UDP input.
        '';
      };

      extraOptions = mkOption {
        type = types.separatedString " ";
        default = "";
        description = lib.mdDoc ''
          Any extra flags to pass to SystemdJournal2Gelf. Note that
          these are basically `journalctl` flags.
        '';
      };

      package = mkPackageOption pkgs "systemd-journal2gelf" { };

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
