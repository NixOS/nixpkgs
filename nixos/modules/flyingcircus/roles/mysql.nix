{ config, lib, pkgs, ... }: with lib;

            
{

    options = {

        flyingcircus.roles.mysql = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable the Flying Circus MySQL server role.";
            };

        };

    };

    config = mkIf config.flyingcircus.roles.mysql.enable {

        services.mysql.enable = true;
        services.mysql.package = pkgs.mysql55;

        jobs.fcio-stubs-mysql = {
            description = "Create FC IO stubs for mysql";
            task = true;

            startOn = "started networking";

            script = 
                ''
                    install -d -o vagrant /etc/mysql/local
                '';
        };

    };
}
