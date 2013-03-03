# NixOS module for lighttpd web server

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.lighttpd;

in

{

  options = {

    services.lighttpd = {

      enable = mkOption {
        default = false;
        type = types.uniq types.bool;
        description = ''
          Enable the lighttpd web server. You must configure it with
          services.lighttpd.configText.
        '';
      };

      configText = mkOption {
        default = "";
        type = types.string;
        example = ''
          server.document-root = "/srv/www/"
          server.port = 80
          server.username = "lighttpd"
          server.groupname = "lighttpd"

          mimetype.assign = (
            ".html" => "text/html", 
            ".txt" => "text/plain",
            ".jpg" => "image/jpeg",
            ".png" => "image/png" 
          )
          
          static-file.exclude-extensions = ( ".fcgi", ".php", ".rb", "~", ".inc" )
          index-file.names = ( "index.html" )
        '';
        description = ''
          Contents of lighttpd configuration file. The user and group
          "lighttpd" is available for privilege separation. See configuration
          tutorial at
          http://redmine.lighttpd.net/projects/lighttpd/wiki/TutorialConfiguration
          or full documentation at
          http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.lighttpd = {
      description = "Lighttpd Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.lighttpd}/sbin/lighttpd -D -f /etc/lighttpd.conf";
      # SIGINT => graceful shutdown
      serviceConfig.KillSignal = "SIGINT";
    };

    environment.etc =
      [
        { source = pkgs.writeText "lighttpd.conf"
            ''
            ${cfg.configText}
            '';
          target = "lighttpd.conf";
        }
      ];

    users.extraUsers.lighttpd = {
      group = "lighttpd";
      description = "lighttpd web server privilege separation user";
    };

    users.extraGroups.lighttpd = {};
  };
}
