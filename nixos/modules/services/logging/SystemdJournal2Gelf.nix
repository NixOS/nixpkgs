{ config, lib, pkgs, ... }:
let cfg = config.services.SystemdJournal2Gelf;
in

{ options = {
    services.SystemdJournal2Gelf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable SystemdJournal2Gelf.
        '';
      };

      graylogServer = lib.mkOption {
        type = lib.types.str;
        example = "graylog2.example.com:11201";
        description = ''
          Host and port of your graylog2 input. This should be a GELF
          UDP input.
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.separatedString " ";
        default = "";
        description = ''
          Any extra flags to pass to SystemdJournal2Gelf. Note that
          these are basically `journalctl` flags.
        '';
      };

      package = lib.mkPackageOption pkgs "systemd-journal2gelf" { };

    };
  };

  config = lib.mkIf cfg.enable {
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
