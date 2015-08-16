{ config, pkgs, lib, ... }: 

with lib;

let
    cfg = config.services.beanstalkd;
in
{
    options = {
        services.beanstalkd = {
            enable = mkEnableOption "beanstalkd, a simple, fast work queue";

            bindAddress = mkOption {
                type = types.string;
                default = "127.0.0.1";
                example = "0.0.0.0";
                description = ''
                    Listen on address.
                '';
            };

            port = mkOption {
                type = types.int;
                default = 11300;
                description = ''
                    Listen on port.
                '';
            };

            dataDir = mkOption {
                type = types.path;
                default = "/var/lib/beanstalkd";
                description = ''
                    Data directory for beanstalkd.
                '';
            };

            extraParams = mkOption {
                type = types.string;
                default = "";
                description = ''
                    Extra command line parameters for beanstalkd.
                '';
            };
        };
    };


    config = mkIf config.services.beanstalkd.enable {
        systemd.services.beanstalkd = {
            description = "Beanstalkd is a simple, fast work queue.";

            after = [ "network.target" ];

            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
                ExecStart = "${pkgs.beanstalkd}/bin/beanstalkd" +
                    " -b ${cfg.dataDir}" +
                    " -l ${cfg.bindAddress}" +
                    " -p ${toString cfg.port}" +
                    " ${cfg.extraParams}";
                User = "nobody";
                Group = "nogroup";
                PermissionsStartOnly = true;
            };

            # TODO: Move users to configuration?
            preStart = ''
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R nobody:nogroup ${cfg.dataDir}
            '';
        };
    };
}
