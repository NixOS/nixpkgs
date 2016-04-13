{ config, lib, pkgs, ... }:

with lib;
let
  gunicorn = pkgs.pythonPackages.gunicorn;
  bepasty = pkgs.pythonPackages.bepasty-server;
  gevent = pkgs.pythonPackages.gevent;
  python = pkgs.pythonPackages.python;
  cfg = config.services.bepasty;
  user = "bepasty";
  group = "bepasty";
  default_home = "/var/lib/bepasty";
in
{
  options.services.bepasty = {
    enable = mkEnableOption "Bepasty servers";

    servers = mkOption {
      default = {};
      description = ''
        configure a number of bepasty servers which will be started with
        gunicorn.
        '';
      type = with types ; attrsOf (submodule ({

        options = {

          bind = mkOption {
            type = types.str;
            description = ''
              Bind address to be used for this server.
              '';
            example = "0.0.0.0:8000";
            default = "127.0.0.1:8000";
          };


          dataDir = mkOption {
            type = types.str;
            description = ''
              Path to the directory where the pastes will be saved to
              '';
            default = default_home+"/data";
          };

          defaultPermissions = mkOption {
            type = types.str;
            description = ''
              default permissions for all unauthenticated accesses.
              '';
            example = "read,create,delete";
            default = "read";
          };

          extraConfig = mkOption {
            type = types.str;
            description = ''
              Extra configuration for bepasty server to be appended on the
              configuration.
              see https://bepasty-server.readthedocs.org/en/latest/quickstart.html#configuring-bepasty
              for all options.
              '';
            default = "";
            example = ''
              PERMISSIONS = {
                'myadminsecret': 'admin,list,create,read,delete',
              }
              MAX_ALLOWED_FILE_SIZE = 5 * 1000 * 1000
              '';
          };

          secretKey = mkOption {
            type = types.str;
            description = ''
              server secret for safe session cookies, must be set.
              '';
            default = "";
          };

          workDir = mkOption {
            type = types.str;
            description = ''
              Path to the working directory (used for config and pidfile).
              Defaults to the users home directory.
              '';
            default = default_home;
          };

        };
      }));
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ bepasty ];

    # creates gunicorn systemd service for each configured server
    systemd.services = mapAttrs' (name: server:
      nameValuePair ("bepasty-server-${name}-gunicorn")
        ({
          description = "Bepasty Server ${name}";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          restartIfChanged = true;

          environment = let
            penv = python.buildEnv.override {
              extraLibs = [ bepasty gevent ];
            };
          in {
            BEPASTY_CONFIG = "${server.workDir}/bepasty-${name}.conf";
            PYTHONPATH= "${penv}/${python.sitePackages}/";
          };

          serviceConfig = {
            Type = "simple";
            PrivateTmp = true;
            ExecStartPre = assert server.secretKey != ""; pkgs.writeScript "bepasty-server.${name}-init" ''
              #!/bin/sh
              mkdir -p "${server.workDir}"
              mkdir -p "${server.dataDir}"
              chown ${user}:${group} "${server.workDir}" "${server.dataDir}"
              cat > ${server.workDir}/bepasty-${name}.conf <<EOF
              SITENAME="${name}"
              STORAGE_FILESYSTEM_DIRECTORY="${server.dataDir}"
              SECRET_KEY="${server.secretKey}"
              DEFAULT_PERMISSIONS="${server.defaultPermissions}"
              ${server.extraConfig}
              EOF
            '';
            ExecStart = ''${gunicorn}/bin/gunicorn bepasty.wsgi --name ${name} \
              -u ${user} \
              -g ${group} \
              --workers 3 --log-level=info \
              --bind=${server.bind} \
              --pid ${server.workDir}/gunicorn-${name}.pid \
              -k gevent
            '';
          };
        })
    ) cfg.servers;

    users.extraUsers = [{
      uid = config.ids.uids.bepasty;
      name = user;
      group = group;
      home = default_home;
    }];

    users.extraGroups = [{
      name = group;
      gid = config.ids.gids.bepasty;
    }];
  };
}
