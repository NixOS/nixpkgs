{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.rspamd-trainer;
  format = pkgs.formats.toml { };

in {
  options.services.rspamd-trainer = {

    enable = mkEnableOption "Spam/ham trainer for rspamd";

    settings = mkOption {
      default = { };
      description = ''
        IMAP authentication configuration for rspamd-trainer. For supplying
        the IMAP password, use the `secrets` option.
      '';
      type = types.submodule {
        freeformType = format.type;
      };
      example = literalExpression ''
        {
          HOST = "localhost";
          USERNAME = "spam@example.com";
          INBOXPREFIX = "INBOX/";
        }
      '';
    };

    secrets = lib.mkOption {
      type = with types; listOf path;
      description = ''
        A list of files containing the various secrets. Should be in the
        format expected by systemd's `EnvironmentFile` directory. For the
        IMAP account password use `PASSWORD = mypassword`.
      '';
      default = [ ];
    };

  };

  config = mkIf cfg.enable {

    systemd = {
      services.rspamd-trainer = {
        description = "Spam/ham trainer for rspamd";
        serviceConfig = {
          ExecStart = "${pkgs.rspamd-trainer}/bin/rspamd-trainer";
          WorkingDirectory = "/var/lib/rspamd-trainer";
          StateDirectory = [ "rspamd-trainer/log" ];
          Type = "oneshot";
          DynamicUser = true;
          EnvironmentFile = [
            ( format.generate "rspamd-trainer-env" cfg.settings )
            cfg.secrets
          ];
        };
      };
      timers."rspamd-trainer" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "10m";
          OnUnitActiveSec = "10m";
          Unit = "rspamd-trainer.service";
        };
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
