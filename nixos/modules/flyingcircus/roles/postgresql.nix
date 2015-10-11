{ config, lib, pkgs, ... }: with lib;


{

    options = {

        flyingcircus.roles.postgresql = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable the Flying Circus PostgreSQL server role.";
            };

        };

    };

    config = mkIf config.flyingcircus.roles.postgresql.enable {

        services.postgresql.enable = true;
        services.postgresql.package = pkgs.postgresql93;

        services.postgresql.initialScript = ./postgresql-init.sql;

    };
}
