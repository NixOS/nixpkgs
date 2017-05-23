{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.passopolis;
in {
  ###### interface

  options = {

    services.passopolis = {

      enable = mkEnableOption "Passopolis";

      user = mkOption {
        type = types.str;
        default = "passopolis";
        description = "User account under which passopolis runs.";
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/passopolis";
        description = "The state directory";
      };

      databaseHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Database hostname";
      };

      databaseName = mkOption {
        type = types.str;
        default = "passopolis";
        description = "Database name";
      };

      enablePostgreSQLDatabase = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable a local postgresql service as database for passopolis
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.passopolis = {
      name = cfg.user;
      description = "Passopolis service user";
    };

    services.postgresql.enable = mkDefault true;

    systemd.services.passopolis = {
      description = "Passopolis service";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; optionals cfg.enablePostgreSQLDatabase [
        config.services.postgresql.package
      ];
      preStart = ''
      mkdir -p ${cfg.statePath}
      chown ${cfg.user} ${cfg.statePath}
      ${lib.optionalString cfg.enablePostgreSQLDatabase ''
        if ! test -e "${cfg.statePath}/db-created"; then
          psql postgres -c "CREATE ROLE ${cfg.user} WITH LOGIN NOCREATEDB NOCREATEROLE NOCREATEUSER"
          ${config.services.postgresql.package}/bin/createdb --owner ${cfg.user} ${cfg.databaseName} || true
          touch "${cfg.statePath}/db-created"
        fi
      ''}
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        ExecStart = "${pkgs.jre}/bin/java -DgenerateSecretsForTest=true -Ddatabase_url=jdbc:postgresql://${cfg.databaseHost}:5432/${cfg.databaseName} -ea -jar ${pkgs.passopolis}/share/java/mitrocore.jar";
        User = cfg.user;
      };
    };
  };
}
