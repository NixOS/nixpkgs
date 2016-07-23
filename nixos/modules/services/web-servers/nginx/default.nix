{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nginx;
  nginx = cfg.package;
  configFileText = ''
    user ${cfg.user} ${cfg.group};
    daemon off;

    ${cfg.config}

    ${optionalString (cfg.httpConfig != "") ''
    http {
      include ${cfg.package}/conf/mime.types;
      ${cfg.httpConfig}
    }
    ''}
    ${cfg.appendConfig}
  '';
  configFile = pkgs.runCommand "nginx.conf" {
    text = configFileText;
    passAsFile = ["text"];
    preferLocalBuild = true;
    allowSubstitutes = false;
  } ''
    mkdir -p "$(dirname "$out")"
    mv "$textPath" "$out"
    (${nginx}/bin/nginx -t -c "$out" -p ${cfg.stateDir} || true) 2>&1 | grep -q 'syntax is ok'
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
        defaultText = "pkgs.nginx";
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
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = "10s";
        StartLimitInterval = "1min";
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
