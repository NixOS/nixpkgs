{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.gatus;

  settingsFormat = pkgs.formats.yaml { };

  inherit (lib)
    getExe
    literalExpression
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  inherit (lib.types)
    bool
    int
    nullOr
    path
    submodule
    ;
in
{
  options.services.gatus = {
    enable = mkEnableOption "Gatus";

    package = mkPackageOption pkgs "gatus" { };

    configFile = mkOption {
      type = path;
      default = settingsFormat.generate "gatus.yaml" cfg.settings;
      defaultText = literalExpression ''
        let settingsFormat = pkgs.formats.yaml { }; in settingsFormat.generate "gatus.yaml" cfg.settings;
      '';
      description = ''
        Path to the Gatus configuration file.
        Overrides any configuration made using the `settings` option.
      '';
    };

    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        File to load as environment file.
        Environmental variables from this file can be interpolated in the configuration file using `''${VARIABLE}`.
        This is useful to avoid putting secrets into the nix store.
      '';
    };

    settings = mkOption {
      type = submodule {
        freeformType = settingsFormat.type;
        options = {
          web.port = mkOption {
            type = int;
            default = 8080;
            description = ''
              The TCP port to serve the Gatus service at.
            '';
          };
        };
      };

      default = { };

      example = literalExpression ''
        {
          web.port = 8080;
          endpoints = [{
            name = "website";
            url = "https://twin.sh/health";
            interval = "5m";
            conditions = [
              "[STATUS] == 200"
              "[BODY].status == UP"
              "[RESPONSE_TIME] < 300"
            ];
          }];
        }
      '';

      description = ''
        Configuration for Gatus.
        Supported options can be found at the [docs](https://gatus.io/docs).
      '';
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to open the firewall for the Gatus web interface.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gatus = {
      description = "Automated developer-oriented status page";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        User = "gatus";
        Group = "gatus";
        Type = "simple";
        Restart = "on-failure";
        ExecStart = getExe cfg.package;
        StateDirectory = "gatus";
        SyslogIdentifier = "gatus";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };

      environment = {
        GATUS_CONFIG_PATH = cfg.configFile;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.settings.web.port ];
  };

  meta.maintainers = with maintainers; [ pizzapim ];
}
