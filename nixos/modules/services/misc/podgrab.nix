{ config, lib, pkgs, ... }:
let
  cfg = config.services.podgrab;
in
{
  options.services.podgrab = with lib; {
    enable = mkEnableOption (lib.mdDoc "Podgrab, a self-hosted podcast manager");

    passwordFile = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/run/secrets/password.env";
      description = lib.mdDoc ''
        The path to a file containing the PASSWORD environment variable
        definition for Podgrab's authentification.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      example = 4242;
      description = lib.mdDoc "The port on which Podgrab will listen for incoming HTTP traffic.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.podgrab = {
      description = "Podgrab podcast manager";
      wantedBy = [ "multi-user.target" ];
      environment = {
        CONFIG = "/var/lib/podgrab/config";
        DATA = "/var/lib/podgrab/data";
        GIN_MODE = "release";
        PORT = toString cfg.port;
      };
      serviceConfig = {
        DynamicUser = true;
        EnvironmentFile = lib.optional (cfg.passwordFile != null) [
          cfg.passwordFile
        ];
        ExecStart = "${pkgs.podgrab}/bin/podgrab";
        WorkingDirectory = "${pkgs.podgrab}/share";
        StateDirectory = [ "podgrab/config" "podgrab/data" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ambroisie ];
}
