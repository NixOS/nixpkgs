{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.services.keycloak;
in
{
  options = {
    services.keycloak = {
      enable = mkEnableOption "Keycloak identity and access server";

      package = mkOption {
        type = types.package;
        default = pkgs.keycloak;
        defaultText = "pkgs.keycloak";
        example = literalExample "pkgs.keycloak";
        description = "Package that should be used for keycloak";
      };

      jbossBaseDir = mkOption {
        type = types.str;
        default = "/var/lib/keycloak";
        description = ''
          The location keycloak (and underlying JBoss/Wildfly) information
          (configuration, logs, data) is stored.
        '';
      };

      user = mkOption {
        type = types.str;
        description = "The user to run keycloak as.";
        default = "keycloak";
      };

      group = mkOption {
        type = types.str;
        description = "The group to run keycloak as.";
        default = "keycloak";
      };

      extraFlags = mkOption {
        description = "Extra flags to pass to the keycloak (standalone.sh) command.";
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.keycloak-server = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Keycloak Open Source Identity and Access Management Server";

      environment = {
        JBOSS_BASE_DIR = jbossBaseDir;
      };

      serviceConfig = {
        User = "${cfg.user}";
        Group = "${cfg.group}";
        TimeoutStartSec = 60;
        TimeoutStopSec = 60;
        Restart = "always";
        ExecStart = concatStringsSep " \\\n " (
          [
            "${cfg.package}/bin/standalone.sh"
          ] ++ cfg.extraFlags
        );
      };
    };
  };
}
