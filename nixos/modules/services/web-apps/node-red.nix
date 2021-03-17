{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.node-red;
in
{
  options.services.node-red = {
    enable = mkEnableOption "the Node-RED service";

    package = mkOption {
      default = pkgs.nodePackages.node-red;
      defaultText = "pkgs.nodePackages.node-red";
      type = types.package;
      description = "Node-RED package to use.";
    };

    configFile = mkOption {
      type = types.path;
      default = "${cfg.package}/lib/node_modules/node-red/settings.js";
      defaultText = "\${cfg.package}/lib/node_modules/node-red/settings.js";
      description = ''
        Path to the JavaScript configuration file.
        See <link
        xlink:href="https://github.com/node-red/node-red/blob/master/packages/node_modules/node-red/settings.js"/>
        for a configuration example.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 1880;
      description = "Listening port.";
    };

    userDir = mkOption {
      type = types.path;
      default = "/var/lib/node-red";
      description = "the directory to store all user data, such as flow and credential files and all library data.";
    };

    safe = mkOption {
      type = types.bool;
      default = "false";
      description = "Whether to launch Node-RED in --safe mode.";
    };

    define = mkOption {
      type = types.attrs;
      default = { };
      description = "List of settings.js overrides to pass via -D to Node-RED.";
      example = literalExample ''
        {
          "logging.console.level=" = "trace";
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.node-red = {
      description = "Node-RED Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        DynamicUser = true;
        Environment = [
          "HOME=${cfg.userDir}"
        ];
        ExecStart = "${cfg.package}/bin/node-red --settings ${cfg.configFile} --port ${toString cfg.port} --userDir ${cfg.userDir} ${concatStringsSep " " (mapAttrsToList (name: value: "-D ${name}=${value}") cfg.define)}";
        PrivateTmp = true;
        Restart = "always";
        StateDirectory = "node-red";
        WorkingDirectory = "${cfg.userDir}";
      };
    };
  };
}
