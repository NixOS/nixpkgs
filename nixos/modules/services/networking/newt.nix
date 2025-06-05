{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.newt;
in
{
  options = {
    services.newt = {
      enable = lib.mkEnableOption "Newt";

      id = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = ''
          The newt-id specified by pangolin on site creation.
        '';
      };
      endpoint = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = ''
          The url of your pangolin dashboard.
        '';
      };
      # provide path to file to keep secrets out of the nix store
      secretFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing your secret key, specified by pangolin on site creation.
        '';
      };
      logLevel = lib.mkOption {
        type = lib.types.enum [
          "DEBUG"
          "INFO"
          "WARN"
          "ERROR"
          "FATAL"
        ];
        default = "INFO";
        description = "How much to log";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.secretFile != null;
        message = "services.newt.secretFile must be provided when newt is enabled";
      }
      {
        assertion = cfg.id != null;
        message = "services.newt.id must be provided when newt is enabled";
      }
      {
        assertion = cfg.endpoint != null;
        message = "services.newt.endpoint must be provided when newt is enabled";
      }
    ];

    systemd.services.newt = {
      description = "Newt, a user space tunnel client to securely expose private resources for Pangolin";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = ''
        NEWT_SECRET=$(cat "$CREDENTIALS_DIRECTORY/NEWT_SECRET_FILE")
        exec ${lib.getExe pkgs.newt-go} \
        --id ${cfg.id} \
        --secret "$NEWT_SECRET" \
        --endpoint ${cfg.endpoint} \
        --log-level ${cfg.logLevel}
      '';
      serviceConfig = {
        DynamicUser = true;
        User = "newt";
        Group = "newt";
        StateDirectory = "newt";
        WorkingDirectory = "%S/newt";
        Restart = "always";
        RestartSec = "10s";
        LoadCredential = "NEWT_SECRET_FILE:${cfg.secretFile}";
      };
    };
  };
}
