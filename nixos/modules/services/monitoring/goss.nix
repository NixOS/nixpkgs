{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.goss;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "goss.yaml" cfg.settings;

in
{
  meta = {
    doc = ./goss.md;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };

  options = {
    services.goss = {
      enable = lib.mkEnableOption "Goss daemon";

      package = lib.mkPackageOption pkgs "goss" { };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          GOSS_FMT = "json";
          GOSS_LOGLEVEL = "FATAL";
          GOSS_LISTEN = ":8080";
        };
        description = ''
          Environment variables to set for the goss service.

          See <https://github.com/goss-org/goss/blob/master/docs/manual.md>
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = settingsFormat.type; };
        default = { };
        example = {
          addr."tcp://localhost:8080" = {
            reachable = true;
            local-address = "127.0.0.1";
          };
          service.goss = {
            enabled = true;
            running = true;
          };
        };
        description = ''
          The global options in `config` file in yaml format.

          Refer to <https://github.com/goss-org/goss/blob/master/docs/goss-json-schema.yaml> for schema.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.goss = {
      description = "Goss - Quick and Easy server validation";
      unitConfig.Documentation = "https://github.com/goss-org/goss/blob/master/docs/manual.md";

      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];

      environment = {
        GOSS_FILE = configFile;
      }
      // cfg.environment;

      reloadTriggers = [ configFile ];

      serviceConfig = {
        DynamicUser = true;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStart = "${cfg.package}/bin/goss serve";
        Group = "goss";
        Restart = "on-failure";
        RestartSec = 5;
        User = "goss";
      };
    };
  };
}
