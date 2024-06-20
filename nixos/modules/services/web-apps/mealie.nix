{ config, lib, pkgs, ...}:
let
  cfg = config.services.mealie;
  pkg = cfg.package;

  # The directory where mealie user data is stored.
  mealieDataDir = "/var/lib/mealie";
in
{
  options.services.mealie = {
    enable = lib.mkEnableOption "Mealie, a recipe manager and meal planner";

    package = lib.mkPackageOption pkgs "mealie" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "mealie";
      description = ''
        The user mealie will run as. If set to `"mealie"` and a user named `"mealie"`
        does not already exist, systemd will dynamically create a `"mealie"` user
        that exists for as long as the `mealie` service is running.

        If a custom data directory for mealie is set (using the `DATA_DIR`
        environment variable), the dynamically-created `"mealie"` user may not
        have permission to write to that directory. This is complicated by the
        fact that dynamic users have a different UID each time they are created.

        In that case, it is recommended to create a user yourself with write
        permissions to the custom `DATA_DIR`, and supply that user's name to
        this option.

        Alternatively, you may create a user named `"mealie"`, give it the appropriate
        permissions and then leave this option as the default value. That user,
        with a stable UID, will then be used and systemd will not dynamically
        generate a new one.

        To reduce confusion, if a custom `DATA_DIR` is configured, then a user
        with the same name as this option's value MUST exist.
      '';
      example = lib.literalExpression ''
        {
          # Create a user for mealie to run as.
          users.users.mealie = {
            isSystemUser = true;
            description = "Mealie service user";
            group = "mealie";
            createHome = false;
          };

          # Ensure that the data directory allows
          # the mealie user to read and write to it.
          systemd.tmpfiles.rules = [
            "d /path/to/data/directory 0755 mealie mealie -"
          ];

          # Enable mealie and set a custom data directory.
          services.mealie = {
            enable = true;
            user = "mealie";
            settings = {
              DATA_DIR = "/path/to/data/directory";

              // Additional options...
            };
          };
        }
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address on which the service should listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "Port on which to serve the Mealie service.";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = {};
      description = ''
        Configuration of the Mealie service.

        See [the mealie documentation](https://nightly.mealie.io/documentation/getting-started/installation/backend-config/) for available options and default values.
      '';
      example = {
        ALLOW_SIGNUP = "false";
      };
    };

    credentialsFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/run/secrets/mealie-credentials.env";
      description = ''
        File containing credentials used in mealie such as {env}`POSTGRES_PASSWORD`
        or sensitive LDAP options.

        Expects the format of an `EnvironmentFile=`, as described by {manpage}`systemd.exec(5)`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mealie = rec {
      description = "Mealie, a self hosted recipe manager and meal planner";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        PRODUCTION = "true";
        ALEMBIC_CONFIG_FILE = "${pkg}/config/alembic.ini";
        API_PORT = toString cfg.port;
        BASE_URL = "http://localhost:${cfg.port}";
        DATA_DIR = mealieDataDir;
        CRF_MODEL_PATH = "${mealieDataDir}/model.crfmodel";
      } // (builtins.mapAttrs (_: val: toString val) cfg.settings);

      serviceConfig = {
        DynamicUser = true;
        User = cfg.user;
        ExecStartPre = "${pkg}/libexec/init_db";
        ExecStart = "${lib.getExe pkg} -b ${cfg.listenAddress}:${builtins.toString cfg.port}";
        EnvironmentFile = lib.mkIf (cfg.credentialsFile != null) cfg.credentialsFile;
        StateDirectory = "mealie";
        StandardOutput="journal";
      }
        # If a custom data directory has been set, then allow the user mealie is
        # running as to write to it. This is only necessary when systemd has
        # dynamically generated a user to run mealie as. Otherwise, it is a no-op.
        #
        # Also, unset the state directory, as mealie won't be writing to it when
        # a custom data directory is in use.
        // lib.mkIf (environment.DATA_DIR != mealieDataDir) {
          ReadWritePaths = [ environment.DATA_DIR ];
          StateDirectory = null;
        };
    };

    assertions = [
      {
        # Assert that a dynamic user is not in use if a custom data directory is
        # set. This is to help users avoid setting a custom data directory which
        # the user that mealie is running as cannot write to.
        assertion = (
          config.systemd.services.mealie.environment.DATA_DIR == mealieDataDir
          || config.users.users ? ${cfg.user}
        );
        description = ''
          When a custom data directory is in use (through the `DATA_DIR`
          environment variable), the `user` option must be set to a system user
          that actually exists. Otherwise, systemd will dynamically create a user,
          and it is unlikely that this user will have the appropriate read/write
          permissions for the custom data directory.

          Please create a user named "${cfg.user}" and give them read/write
          permissions for the configured mealie data directory.

          See the description of the `user` option for more information.
        '';
      }
    ];
  };
}
