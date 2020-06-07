{ config, lib, pkgs, ... }:

with lib;

let
    name = "pterodactyl-daemon";
    cfg = config.services.${name};
    
    daemonDir = cfg.dataDir + "/daemon";
    daemonDataDir = cfg.dataDir + "/daemon-data";
in
{
    options = {
        services.${name} = {
            enable = mkEnableOption ''
                The server control and management daemon built specifically for Pterodactyl Panel
            '';

            dataDir = mkOption {
                type = types.path;
                default = "/var/lib/pterodactyl";
                description = "
                    The directory in which the daemon configs and data are stored.
                
                    This does not have to be the same as the panel directory.
                ";
            };

            configFile = mkOption {
                type = types.path;
                description = "
                    The JSON configuration file provided by the panel. 

                    You have to add an configure a location and node inside the panel to obtain the configuration file.
                ";
            };
        };
    };

    config = mkIf cfg.enable { 
         systemd.services."${name}-setup" = {
            wantedBy = [ "multi-user.target" ];
            before = [ "${name}.service" ];
            serviceConfig.Type = "oneshot";

            script = ''
                mkdir -p "${daemonDir}"/logs
                mkdir -p "${daemonDir}"/config/{credentials/servers,eggs}
                
                mkdir -p "${daemonDataDir}"

                cat "${cfg.configFile}" > "${daemonDir}/config/core.json"
            '';
         };

        systemd.services.${name} = {
            description = "The server control and management daemon built specifically for Pterodactyl Panel";
            after = [ "docker.service" ] ;
            wantedBy = [ "multi-user.target" ];

            path = with pkgs; [ unzip gnutar ];

            environment = {
                DATA_DIR = daemonDir;
            };

            serviceConfig = {
                WorkingDirectory = daemonDir;
                LimitNOFILE = 4096;
                PIDFile = "/var/run/wings/daemon.pid";
                ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.pterodactylDaemon}/lib/node_modules/pteronode/src/index.js";
                Restart = "on-failure";
                StartLimitInterval = 600;
            };
        };

        networking.firewall.allowedTCPPorts = [ 80 8080 ];

        virtualisation.docker.enable = true;
    };
}