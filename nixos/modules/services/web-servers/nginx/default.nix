{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  nginx = cfg.package;
  configFile = pkgs.writeText "nginx.conf" ''
    user ${cfg.user} ${cfg.group};
    daemon off;
    ${cfg.config}
    ${optionalString (cfg.httpConfig != "") ''
    http {
      ${cfg.httpConfig}
    }
    ''}
    ${cfg.appendConfig}
  '';
in

{
  options = {
    services.nginx = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "
          Enable the nginx Web Server.
        ";
      };

      package = mkOption {
        default = pkgs.nginx;
        type = types.package;
        description = "
          Nginx package to use.
        ";
      };

      config = mkOption {
        default = "events {}";
        description = "
          Verbatim nginx.conf configuration.
        ";
      };

      appendConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration lines appended to the generated Nginx
          configuration file. Commonly used by different modules
          providing http snippets. <option>appendConfig</option>
          can be specified more than once and it's value will be
          concatenated (contrary to <option>config</option> which
          can be set only once).
        '';
      };

      httpConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Configuration lines to be appended inside of the http {} block.";
      };

      http.servers = mkOption {
        description = ''
          http servers
        '';

        default = {};

        type = types.loaOf (types.submodule (
          {
            options = {
              server_name = mkOption {
                description = "name_servers option contents as list of strings.";
                type = types.listOf types.string;
              };
              listen = mkOption {
                description = ''
                  Either port or IP:PORT. <code>ssl</code> will be added if
                  you set sslCert and sslKey.
                  Use <option>defaultServer</option> to append <code>default_server</code>.
                '';
                type = types.string;
              };
              defaultServer = mkOption {
                default = false;
                type = types.bool;
                description = ''
                  Set to true if this server should be the default server.
                '';
              };
              sslCert = mkOption {
                type = types.string;
                description = "ssl cert";
                default = "";
              };
              sslKey = mkOption {
                type = types.string;
                description = "ssl key";
                default = "";
              };
              errorLog = mkOption {
                type = types.string;
                default = "";
              };
              accessLog = mkOption {
                type = types.string;
                default = "";
              };
              preConfig = mkOption {
                type = types.lines;
                default = "";
                description = ''
                  Configuration which should be put first in server { .. } section.
                  Use this for logfile declaration
                '';
              };
              config = mkOption {
                description = ''
                  contents of this server section
                '';
                type = types.lines;
                default = "";
              };
            };
          }
        ));
      };

      stateDir = mkOption {
        default = "/var/spool/nginx";
        description = "
          Directory holding all state for nginx to run.
        ";
      };

      user = mkOption {
        type = types.str;
        default = "nginx";
        description = "User account under which nginx runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        description = "Group account under which nginx runs.";
      };

    };

  };

  config = mkIf cfg.enable {
    # TODO: test user supplied config file pases syntax test

    environment.systemPackages = [ nginx ];

    services.nginx.httpConfig =
      concatMapStrings (server:
        let defaultServer = optionalString server.defaultServer "default_server";
            accessLog = optionalString (server.accessLog != "")  "error_log ${errorLog}";
            errorLog = optionalString (server.errorLog != "")    "access_log ${accessLog}";
            listen =
              if server.sslCert != "" && server.sslKey != ""
              then ''
                listen ${server.listen} ssl ${defaultServer};
                ssl_certificate     ${server.sslCert};
                ssl_certificate_key ${server.sslKey};
                ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
                ssl_ciphers         HIGH:!aNULL:!MD5;
              '' else ''
                listen ${server.listen} ${defaultServer};
              '';
        in ''
        server {
          ${listen}
          server_name = ${concatStringsSep " " server.server_name};
          ${accessLog}
          ${errorLog}
          ${server.preConfig}

          ${server.config}
        }
      '') (attrValues cfg.http.servers);

    systemd.services.nginx = {
      description = "Nginx Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ nginx ];
      preStart =
        ''
        mkdir -p ${cfg.stateDir}/logs
        chmod 700 ${cfg.stateDir}
        chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
        '';
      serviceConfig = {
        ExecStart = "${nginx}/bin/nginx -c ${configFile} -p ${cfg.stateDir}";
      };
    };

    users.extraUsers = optionalAttrs (cfg.user == "nginx") (singleton
      { name = "nginx";
        group = cfg.group;
        uid = config.ids.uids.nginx;
      });

    users.extraGroups = optionalAttrs (cfg.group == "nginx") (singleton
      { name = "nginx";
        gid = config.ids.gids.nginx;
      });
  };
}
