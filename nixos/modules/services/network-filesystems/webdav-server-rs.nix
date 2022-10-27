{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.webdav-server-rs;
  format = pkgs.formats.toml { };
  settings = recursiveUpdate
    {
      server.uid = config.users.users."${cfg.user}".uid;
      server.gid = config.users.groups."${cfg.group}".gid;
    }
    cfg.settings;
in
{
  options = {
    services.webdav-server-rs = {
      enable = mkEnableOption (lib.mdDoc "WebDAV server");

      user = mkOption {
        type = types.str;
        default = "webdav";
        description = lib.mdDoc "User to run under when setuid is not enabled.";
      };

      group = mkOption {
        type = types.str;
        default = "webdav";
        description = lib.mdDoc "Group to run under when setuid is not enabled.";
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = lib.mdDoc ''
          Attrset that is converted and passed as config file. Available
          options can be found at
          [here](https://github.com/miquels/webdav-server-rs/blob/master/webdav-server.toml).
        '';
        example = literalExpression ''
          {
            server.listen = [ "0.0.0.0:4918" "[::]:4918" ];
            accounts = {
              auth-type = "htpasswd.default";
              acct-type = "unix";
            };
            htpasswd.default = {
              htpasswd = "/etc/htpasswd";
            };
            location = [
              {
                route = [ "/public/*path" ];
                directory = "/srv/public";
                handler = "filesystem";
                methods = [ "webdav-ro" ];
                autoindex = true;
                auth = "false";
              }
              {
                route = [ "/user/:user/*path" ];
                directory = "~";
                handler = "filesystem";
                methods = [ "webdav-rw" ];
                autoindex = true;
                auth = "true";
                setuid = true;
              }
            ];
          }
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = format.generate "webdav-server.toml" settings;
        defaultText = "Config file generated from services.webdav-server-rs.settings";
        description = lib.mdDoc ''
          Path to config file. If this option is set, it will override any
          configuration done in services.webdav-server-rs.settings.
        '';
        example = "/etc/webdav-server.toml";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasAttr cfg.user config.users.users && config.users.users."${cfg.user}".uid != null;
        message = "users.users.${cfg.user} and users.users.${cfg.user}.uid must be defined.";
      }
      {
        assertion = hasAttr cfg.group config.users.groups && config.users.groups."${cfg.group}".gid != null;
        message = "users.groups.${cfg.group} and users.groups.${cfg.group}.gid must be defined.";
      }
    ];

    users.users = optionalAttrs (cfg.user == "webdav") {
      webdav = {
        description = "WebDAV user";
        group = cfg.group;
        uid = config.ids.uids.webdav;
      };
    };

    users.groups = optionalAttrs (cfg.group == "webdav") {
      webdav.gid = config.ids.gids.webdav;
    };

    systemd.services.webdav-server-rs = {
      description = "WebDAV server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.webdav-server-rs}/bin/webdav-server -c ${cfg.configFile}";

        CapabilityBoundingSet = [
          "CAP_SETUID"
          "CAP_SETGID"
        ];

        NoExecPaths = [ "/" ];
        ExecPaths = [ "/nix/store" ];

        # This program actively detects if it is running in root user account
        # when it starts and uses root privilege to switch process uid to
        # respective unix user when a user logs in.  Maybe we can enable
        # DynamicUser in the future when it's able to detect CAP_SETUID and
        # CAP_SETGID capabilities.

        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ pmy ];
}
