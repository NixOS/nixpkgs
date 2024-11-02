{ config, lib, pkgs, ... }:
let
  cfg = config.services.webdav;
  format = pkgs.formats.yaml { };
in
{
  options = {
    services.webdav = {
      enable = lib.mkEnableOption "WebDAV server";

      user = lib.mkOption {
        type = lib.types.str;
        default = "webdav";
        description = "User account under which WebDAV runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "webdav";
        description = "Group under which WebDAV runs.";
      };

      settings = lib.mkOption {
        type = format.type;
        default = { };
        description = ''
          Attrset that is converted and passed as config file. Available options
          can be found at
          [here](https://github.com/hacdias/webdav).

          This program supports reading username and password configuration
          from environment variables, so it's strongly recommended to store
          username and password in a separate
          [EnvironmentFile](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#EnvironmentFile=).
          This prevents adding secrets to the world-readable Nix store.
        '';
        example = lib.literalExpression ''
          {
              address = "0.0.0.0";
              port = 8080;
              scope = "/srv/public";
              modify = true;
              auth = true;
              users = [
                {
                  username = "{env}ENV_USERNAME";
                  password = "{env}ENV_PASSWORD";
                }
              ];
          }
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = format.generate "webdav.yaml" cfg.settings;
        defaultText = "Config file generated from services.webdav.settings";
        description = ''
          Path to config file. If this option is set, it will override any
          configuration done in options.services.webdav.settings.
        '';
        example = "/etc/webdav/config.yaml";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Environment file as defined in {manpage}`systemd.exec(5)`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "webdav") {
      webdav = {
        description = "WebDAV daemon user";
        group = cfg.group;
        uid = config.ids.uids.webdav;
      };
    };

    users.groups = lib.mkIf (cfg.group == "webdav") {
      webdav.gid = config.ids.gids.webdav;
    };

    systemd.services.webdav = {
      description = "WebDAV server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.webdav}/bin/webdav -c ${cfg.configFile}";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ pmy ];
}
