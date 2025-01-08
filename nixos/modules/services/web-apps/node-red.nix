{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.node-red;
  defaultUser = "node-red";
in
{
  options.services.node-red = {
    enable = lib.mkEnableOption "the Node-RED service";

    package = lib.mkPackageOption pkgs [ "node-red" ] { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open ports in the firewall for the server.
      '';
    };

    withNpmAndGcc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Give Node-RED access to NPM and GCC at runtime, so 'Nodes' can be
        downloaded and managed imperatively via the 'Palette Manager'.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.package}/lib/node_modules/node-red/packages/node_modules/node-red/settings.js";
      defaultText = lib.literalExpression ''"''${package}/lib/node_modules/node-red/packages/node_modules/node-red/settings.js"'';
      description = ''
        Path to the JavaScript configuration file.
        See <https://github.com/node-red/node-red/blob/master/packages/node_modules/node-red/settings.js>
        for a configuration example.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1880;
      description = "Listening port.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        User under which Node-RED runs.If left as the default value this user
        will automatically be created on system activation, otherwise the
        sysadmin is responsible for ensuring the user exists.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        Group under which Node-RED runs.If left as the default value this group
        will automatically be created on system activation, otherwise the
        sysadmin is responsible for ensuring the group exists.
      '';
    };

    userDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/node-red";
      description = ''
        The directory to store all user data, such as flow and credential files and all library data. If left
        as the default value this directory will automatically be created before the node-red service starts,
        otherwise the sysadmin is responsible for ensuring the directory exists with appropriate ownership
        and permissions.
      '';
    };

    safe = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to launch Node-RED in --safe mode.";
    };

    define = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "List of settings.js overrides to pass via -D to Node-RED.";
      example = lib.literalExpression ''
        {
          "logging.console.level" = "trace";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        group = defaultUser;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.node-red = {
      description = "Node-RED Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      environment = {
        HOME = cfg.userDir;
      };
      path = lib.optionals cfg.withNpmAndGcc [
        pkgs.nodejs
        pkgs.gcc
      ];
      serviceConfig = lib.mkMerge [
        {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${cfg.package}/bin/node-red ${pkgs.lib.optionalString cfg.safe "--safe"} --settings ${cfg.configFile} --port ${toString cfg.port} --userDir ${cfg.userDir} ${
            lib.concatStringsSep " " (lib.mapAttrsToList (name: value: "-D ${name}=${value}") cfg.define)
          }";
          PrivateTmp = true;
          Restart = "always";
          WorkingDirectory = cfg.userDir;
        }
        (lib.mkIf (cfg.userDir == "/var/lib/node-red") { StateDirectory = "node-red"; })
      ];
    };
  };
}
