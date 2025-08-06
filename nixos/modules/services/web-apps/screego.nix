{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types mkIf;
  cfg = config.services.screego;
  defaultSettings = {
    SCREEGO_SERVER_ADDRESS = "127.0.0.1:5050";
    SCREEGO_TURN_ADDRESS = "0.0.0.0:3478";
    SCREEGO_TURN_PORT_RANGE = "50000:55000";
    SCREEGO_SESSION_TIMEOUT_SECONDS = "0";
    SCREEGO_CLOSE_ROOM_WHEN_OWNER_LEAVES = "true";
    SCREEGO_AUTH_MODE = "turn";
    SCREEGO_LOG_LEVEL = "info";
  };
in
{
  meta.maintainers = with lib.maintainers; [ pinpox ];

  options.services.screego = {

    enable = lib.mkEnableOption "screego screen-sharing server for developers";

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open the firewall port(s).
      '';
    };

    environmentFile = mkOption {
      default = null;
      description = ''
        Environment file (see {manpage}`systemd.exec(5)` "EnvironmentFile="
        section for the syntax) passed to the service. This option can be
        used to safely include secrets in the configuration.
      '';
      example = "/run/secrets/screego-envfile";
      type = with types; nullOr path;
    };

    settings = lib.mkOption {
      type = types.attrsOf types.str;
      description = ''
        Screego settings passed as Nix attribute set, they will be merged with
        the defaults. Settings will be passed as environment variables.

        See <https://screego.net/#/config> for possible values
      '';
      default = defaultSettings;
      example = {
        SCREEGO_EXTERNAL_IP = "dns:example.com";
      };
    };
  };

  config =
    let
      # User-provided settings should be merged with default settings,
      # overwriting where necessary
      mergedConfig = defaultSettings // cfg.settings;
      turnUDPPorts = lib.splitString ":" mergedConfig.SCREEGO_TURN_PORT_RANGE;
      turnPort = lib.toInt (builtins.elemAt (lib.splitString ":" mergedConfig.SCREEGO_TURN_ADDRESS) 1);
    in
    mkIf (cfg.enable) {

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ turnPort ];
        allowedUDPPorts = [ turnPort ];
        allowedUDPPortRanges = [
          {
            from = lib.toInt (builtins.elemAt turnUDPPorts 0);
            to = lib.toInt (builtins.elemAt turnUDPPorts 1);
          }
        ];
      };

      systemd.services.screego = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "screego screen-sharing for developers";
        environment = mergedConfig;
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${lib.getExe pkgs.screego} serve";
          Restart = "on-failure";
          RestartSec = "5s";
        }
        // lib.optionalAttrs (cfg.environmentFile != null) { EnvironmentFile = cfg.environmentFile; };
      };
    };
}
