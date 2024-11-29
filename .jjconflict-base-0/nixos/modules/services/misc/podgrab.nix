{ config, lib, pkgs, ... }:
let
  cfg = config.services.podgrab;

  stateDir = "/var/lib/podgrab";
in
{
  options.services.podgrab = with lib; {
    enable = mkEnableOption "Podgrab, a self-hosted podcast manager";

    passwordFile = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "/run/secrets/password.env";
      description = ''
        The path to a file containing the PASSWORD environment variable
        definition for Podgrab's authentication.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      example = 4242;
      description = "The port on which Podgrab will listen for incoming HTTP traffic.";
    };

    dataDirectory = mkOption {
      type = types.path;
      default = "${stateDir}/data";
      example = "/mnt/podcasts";
      description = "Directory to store downloads.";
    };

    user = mkOption {
      type = types.str;
      default = "podgrab";
      description = "User under which Podgrab runs, and which owns the download directory.";
    };

    group = mkOption {
      type = types.str;
      default = "podgrab";
      description = "Group under which Podgrab runs, and which owns the download directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-pyload" = {
      ${cfg.dataDirectory}.d = { inherit (cfg) user group; };
    };

    systemd.services.podgrab = {
      description = "Podgrab podcast manager";
      wantedBy = [ "multi-user.target" ];
      environment = {
        CONFIG = "${stateDir}/config";
        DATA = cfg.dataDirectory;
        GIN_MODE = "release";
        PORT = toString cfg.port;
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.optionals (cfg.passwordFile != null) [
          cfg.passwordFile
        ];
        ExecStart = "${pkgs.podgrab}/bin/podgrab";
        WorkingDirectory = "${pkgs.podgrab}/share";
        StateDirectory = [ "podgrab/config" ];
      };
    };

    users.users.podgrab = lib.mkIf (cfg.user == "podgrab") {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.podgrab = lib.mkIf (cfg.group == "podgrab") { };
  };

  meta.maintainers = with lib.maintainers; [ ambroisie ];
}
