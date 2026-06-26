{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.ha-linky;
  format = pkgs.formats.json { };
in

{
  options.services.ha-linky = {
    enable = mkEnableOption "A Home Assistant app to sync Energy dashboards with your Linky smart meter";

    package = mkPackageOption pkgs "ha-linky" { };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/ha-linky-secrets";
      description = ''
        Environment file use to pass variables and secrets into the runtime.
      '';
    };

    settings = mkOption {
      type = format.type;
      description = ''
        ha-linky configuraiton as a nix attribute set. It supports substitution using `envsubst` from the `environmentFile`.

        Check [ha-linky's README](https://github.com/bokub/ha-linky) for possible options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.ha-linky =
      let
        configFile = format.generate "options.json" cfg.settings;
        configPath = "/run/ha-linky/options.json";
      in
      {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          CONFIG_PATH = configPath;
        };

        serviceConfig = {
          EnvironmentFile = lib.optionals (cfg.environmentFile != null) [ cfg.environmentFile ];
          ExecStartPre = utils.escapeSystemdExecArgs [
            (lib.getExe pkgs.envsubst)
            "-i"
            configFile
            "-o"
            configPath
          ];
          ExecStart = utils.escapeSystemdExecArgs [
            (lib.getExe cfg.package)
          ];
          DynamicUser = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectHome = true;
          Restart = "on-failure";
          RuntimeDirectory = "ha-linky";
          StateDirectory = "ha-linky";
          User = "evcc";
        };
      };
  };

  meta.maintainers = with lib.maintainers; [ ratcornu ];
}
