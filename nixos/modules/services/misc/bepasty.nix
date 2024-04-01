{ config, lib, pkgs, ... }:

with lib;
let
  gunicorn = pkgs.python3Packages.gunicorn;
  bepasty = pkgs.bepasty;
  gevent = pkgs.python3Packages.gevent;
  python = pkgs.python3Packages.python;
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
      description = lib.mdDoc ''
        configure a number of bepasty servers which will be started with
        gunicorn.
        '';
      type = with types ; attrsOf (submodule ({ config, ... } : {

        options = {

          bind = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Bind address to be used for this server.
              '';
            example = "0.0.0.0:8000";
            default = "127.0.0.1:8000";
          };

          dataDir = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Path to the directory where the pastes will be saved to
              '';
            default = default_home+"/data";
          };

          defaultPermissions = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              default permissions for all unauthenticated accesses.
              '';
            example = "read,create,delete";
            default = "read";
          };

          extraConfig = mkOption {
            type = types.lines;
            description = lib.mdDoc ''
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
            description = lib.mdDoc ''
              server secret for safe session cookies, must be set.

              Warning: this secret is stored in the WORLD-READABLE Nix store!

              It's recommended to use {option}`secretKeyFile`
              which takes precedence over {option}`secretKey`.
              '';
            default = "";
          };

          secretKeyFile = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc ''
              A file that contains the server secret for safe session cookies, must be set.

              {option}`secretKeyFile` takes precedence over {option}`secretKey`.

              Warning: when {option}`secretKey` is non-empty {option}`secretKeyFile`
              defaults to a file in the WORLD-READABLE Nix store containing that secret.
              '';
          };

          workDir = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Path to the working directory (used for config and pidfile).
              Defaults to the users home directory.
              '';
            default = default_home;
          };

        };
        config = {
          secretKeyFile = mkDefault (
            if config.secretKey != ""
            then toString (pkgs.writeTextFile {
              name = "bepasty-secret-key";
              text = config.secretKey;
            })
            else null
          );
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
            ExecStartPre = assert server.secretKeyFile != null; pkgs.writeScript "bepasty-server.${name}-init" ''
              #!/bin/sh
              mkdir -p "${server.workDir}"
              mkdir -p "${server.dataDir}"
              chown ${user}:${group} "${server.workDir}" "${server.dataDir}"
              cat > ${server.workDir}/bepasty-${name}.conf <<EOF
              SITENAME="${name}"
              STORAGE_FILESYSTEM_DIRECTORY="${server.dataDir}"
              SECRET_KEY="$(cat "${server.secretKeyFile}")"
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

    users.users.${user} =
      { uid = config.ids.uids.bepasty;
        group = group;
        home = default_home;
      };

    users.groups.${group}.gid = config.ids.gids.bepasty;
  };
}
