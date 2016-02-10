{ config, lib, pkgs, ... }: with lib;

{

    options = {

        flyingcircus.roles.sensuserver = {

            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable the Flying Circus sensu server role.";
            };

        };

    };

    config = mkIf config.flyingcircus.roles.sensuserver.enable {

        flyingcircus.services.sensu-server.enable = true;
        flyingcircus.services.sensu-api.enable = true;
        flyingcircus.services.uchiwa.enable = true;

        flyingcircus.roles.nginx.enable = true;
        flyingcircus.roles.nginx.httpConfig = ''
          server {
            server_name sensu.dev.gocept.net;
            listen 80;
            listen [::]:80;

            location / {
                proxy_pass http://localhost:3000;
            }
          }
        '';

    };
}
