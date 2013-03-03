{ config, pkgs, ... }:
 
with pkgs.lib;
 
let
  cfg = config.services.nginx;
  configFile = pkgs.writeText "nginx.conf" ''
    ${cfg.config}
  '';
in
 
{
  options = {
    services.nginx = {
      enable = mkOption {
        default = false;
        description = "
          Enable the nginx Web Server.
        ";
      };
 
      config = mkOption {
        default = "";
        description = "
          Verbatim nginx.conf configuration.
        ";
      };

      stateDir = mkOption {
        default = "/var/spool/nginx";
        description = "
          Directory holding all state for nginx to run.
        ";
      };
    };
 
  };
 
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nginx ];

    # TODO: test user supplied config file pases syntax test
 
    systemd.services.nginx = {
      description = "Nginx Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.nginx ];
      preStart =
        ''
        mkdir -p ${cfg.stateDir}/logs
        chown -R nginx:nginx ${cfg.stateDir}
        '';
      serviceConfig = {
        ExecStart = "${pkgs.nginx}/bin/nginx -c ${configFile} -p ${cfg.stateDir}";
      };
    };
 
    users.extraUsers.nginx = {
      group = "nginx";
    };
 
    users.extraGroups.nginx = {};
  };
}
