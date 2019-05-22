{ config, lib, pkgs, ... }:

with lib;
let
  gunicorn = pkgs.python3Packages.gunicorn;
  bepasty = pkgs.bepasty;
  gevent = pkgs.python3Packages.gevent;
  python = pkgs.python3;
  cfg = config.services.bepasty;
in
{
  options.services.bepasty = {
    servers = mkOption {
      default = {};
      description = ''
        Configure a number of bepasty servers which will be started with
        gunicorn.
        '';
      type = with types ; attrsOf (submodule ({ config, ... } : {

        options = {

          bind = mkOption {
            type = types.str;
            description = ''
              Bind address to be used for this server.
              '';
            example = "0.0.0.0:8000";
            default = "127.0.0.1:8000";
          };

          defaultPermissions = mkOption {
            type = types.str;
            description = ''
              Default permissions for all unauthenticated accesses.
              '';
            example = "read,create,delete";
            default = "read";
          };

          extraConfig = mkOption {
            type = types.lines;
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

          extraConfigFile = mkOption {
            type = types.nullOr types.str;
            description = ''
              File that is appended to the default configuration.
              May help you to keep your permissions out of your nix store.
              '';
            default = null;
            example = "/var/lib/secrets/bepasty/permissions.conf";
          };

          secretKey = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Server secret for safe session cookies, must be set.

              Warning: this secret is stored in the WORLD-READABLE Nix store!

              It's recommended to use <option>secretKeyFile</option>
              which takes precedence over <option>secretKey</option>.
              '';
          };

          secretKeyFile = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              A file that contains the server secret for safe session cookies, must be set.

              <option>secretKeyFile</option> takes precedence over <option>secretKey</option>.

              Warning: when <option>secretKey</option> is non-empty <option>secretKeyFile</option>
              defaults to a file in the WORLD-READABLE Nix store containing that secret.
              '';
          };
        };
        config = {
          secretKeyFile = mkDefault (
            if config.secretKey != null
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

  config = mkIf (cfg.servers != {}) {

    environment.systemPackages = [ bepasty ];

    assertions = mapAttrsToList (name: config: {
      assertion = config.secretKey != null || config.secretKeyFile != null;
      message = "The ${name} bepasty server has neither a secret key nor a secret key file.";
    }) cfg.servers;

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
            BEPASTY_CONFIG = "/tmp/bepasty.conf";
            PYTHONPATH= "${penv}/${python.sitePackages}/";
          };

          serviceConfig = {
            Type = "simple";
            ProtectSystem = "strict";
            PrivateHome = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            CapabilityBoundingSet = "";
            NoNewPrivileges = true;
            LockPersonality = true;
            RestrictRealtime = true;
            PrivateMounts = true;
            PrivateUsers = true;
            DynamicUser = true;
            StateDirectory = "bepasty-${name}";
            RuntimeDirectory = "bepasty-${name}";

            ExecStartPre = "+" + pkgs.writeShellScriptBin "bepasty-${name}-prestart" ''
              cat > /tmp/bepasty.conf <<EOF
              SITENAME="${name}"
              STORAGE_FILESYSTEM_DIRECTORY="/var/lib/bepasty-${name}"
              SECRET_KEY="$(cat "${server.secretKeyFile}")"
              DEFAULT_PERMISSIONS="${server.defaultPermissions}"
              ${server.extraConfig}
              ${optionalString (server.extraConfigFile != null) ''$(cat "${server.extraConfigFile}")''}
              EOF

              # This will allow the dynamic user to access the file (we don't know the username yet).
              # It's not too insecure as we have a private /tmp directory that is only root-accessible.
              chmod 444 /tmp/bepasty.conf
            '' + "/bin/bepasty-${name}-prestart";

            ExecStart = ''${gunicorn}/bin/gunicorn bepasty.wsgi --name ${name} \
              --workers 3 --log-level=info \
              --bind=${server.bind} \
              --pid /run/bepasty-${name}/gunicorn.pid \
              -k gevent
            '';
          };
        })
    ) cfg.servers;
  };
}
