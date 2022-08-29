{ config, lib, pkgs, buildEnv, ... }:

with lib;

let
  defaultUser = "healthchecks";
  cfg = config.services.healthchecks;
  pkg = cfg.package;
  boolToPython = b: if b then "True" else "False";
  environment = {
    PYTHONPATH = pkg.pythonPath;
    STATIC_ROOT = cfg.dataDir + "/static";
    DB_NAME = "${cfg.dataDir}/healthchecks.sqlite";
  } // cfg.settings;

  environmentFile = pkgs.writeText "healthchecks-environment" (lib.generators.toKeyValue { } environment);

  healthchecksManageScript = with pkgs; (writeShellScriptBin "healthchecks-manage" ''
    if [[ "$USER" != "${cfg.user}" ]]; then
        echo "please run as user 'healtchecks'." >/dev/stderr
        exit 1
    fi
    export $(cat ${environmentFile} | xargs);
    exec ${pkg}/opt/healthchecks/manage.py "$@"
  '');
in
{
  options.services.healthchecks = {
    enable = mkEnableOption (lib.mdDoc "healthchecks") // {
      description = lib.mdDoc ''
        Enable healthchecks.
        It is expected to be run behind a HTTP reverse proxy.
      '';
    };

    package = mkOption {
      default = pkgs.healthchecks;
      defaultText = literalExpression "pkgs.healthchecks";
      type = types.package;
      description = lib.mdDoc "healthchecks package to use.";
    };

    user = mkOption {
      default = defaultUser;
      type = types.str;
      description = ''
        User account under which healthchecks runs.

        <note><para>
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the healthchecks service starts.
        </para></note>
      '';
    };

    group = mkOption {
      default = defaultUser;
      type = types.str;
      description = ''
        Group account under which healthchecks runs.

        <note><para>
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the healthchecks service starts.
        </para></note>
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "Address the server will listen on.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = lib.mdDoc "Port the server will listen on.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/healthchecks";
      description = ''
        The directory used to store all data for healthchecks.

        <note><para>
        If left as the default value this directory will automatically be created before
        the healthchecks server starts, otherwise you are responsible for ensuring the
        directory exists with appropriate ownership and permissions.
        </para></note>
      '';
    };

    settings = lib.mkOption {
      description = ''
        Environment variables which are read by healthchecks <literal>(local)_settings.py</literal>.

        Settings which are explictly covered in options bewlow, are type-checked and/or transformed
        before added to the environment, everything else is passed as a string.

        See <link xlink:href="">https://healthchecks.io/docs/self_hosted_configuration/</link>
        for a full documentation of settings.

        We add two variables to this list inside the packages <literal>local_settings.py.</literal>
        - STATIC_ROOT to set a state directory for dynamically generated static files.
        - SECRET_KEY_FILE to read SECRET_KEY from a file at runtime and keep it out of /nix/store.
      '';
      type = types.submodule {
        freeformType = types.attrsOf types.str;
        options = {
          ALLOWED_HOSTS = lib.mkOption {
            type = types.listOf types.str;
            default = [ "*" ];
            description = lib.mdDoc "The host/domain names that this site can serve.";
            apply = lib.concatStringsSep ",";
          };

          SECRET_KEY_FILE = mkOption {
            type = types.path;
            description = lib.mdDoc "Path to a file containing the secret key.";
          };

          DEBUG = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Enable debug mode.";
            apply = boolToPython;
          };

          REGISTRATION_OPEN = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              A boolean that controls whether site visitors can create new accounts.
              Set it to false if you are setting up a private Healthchecks instance,
              but it needs to be publicly accessible (so, for example, your cloud
              services can send pings to it).
              If you close new user registration, you can still selectively invite
              users to your team account.
            '';
            apply = boolToPython;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ healthchecksManageScript ];

    systemd.targets.healthchecks = {
      description = "Target for all Healthchecks services";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "network-online.target" ];
    };

    systemd.services =
      let
        commonConfig = {
          WorkingDirectory = cfg.dataDir;
          User = cfg.user;
          Group = cfg.group;
          EnvironmentFile = environmentFile;
          StateDirectory = mkIf (cfg.dataDir == "/var/lib/healthchecks") "healthchecks";
          StateDirectoryMode = mkIf (cfg.dataDir == "/var/lib/healthchecks") "0750";
        };
      in
        {
        healthchecks-migration = {
          description = "Healthchecks migrations";
          wantedBy = [ "healthchecks.target" ];

          serviceConfig = commonConfig // {
            Restart = "on-failure";
            Type = "oneshot";
            ExecStart = ''
              ${pkg}/opt/healthchecks/manage.py migrate
            '';
          };
        };

        healthchecks = {
          description = "Healthchecks WSGI Service";
          wantedBy = [ "healthchecks.target" ];
          after = [ "healthchecks-migration.service" ];

          preStart = ''
            ${pkg}/opt/healthchecks/manage.py collectstatic --no-input
            ${pkg}/opt/healthchecks/manage.py remove_stale_contenttypes --no-input
            ${pkg}/opt/healthchecks/manage.py compress
          '';

          serviceConfig = commonConfig // {
            Restart = "always";
            ExecStart = ''
              ${pkgs.python3Packages.gunicorn}/bin/gunicorn hc.wsgi \
                --bind ${cfg.listenAddress}:${toString cfg.port} \
                --pythonpath ${pkg}/opt/healthchecks
            '';
          };
        };

        healthchecks-sendalerts = {
          description = "Healthchecks Alert Service";
          wantedBy = [ "healthchecks.target" ];
          after = [ "healthchecks.service" ];

          serviceConfig = commonConfig // {
            Restart = "always";
            ExecStart = ''
              ${pkg}/opt/healthchecks/manage.py sendalerts
            '';
          };
        };

        healthchecks-sendreports = {
          description = "Healthchecks Reporting Service";
          wantedBy = [ "healthchecks.target" ];
          after = [ "healthchecks.service" ];

          serviceConfig = commonConfig // {
            Restart = "always";
            ExecStart = ''
              ${pkg}/opt/healthchecks/manage.py sendreports --loop
            '';
          };
        };
      };

    users.users = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} =
        {
          description = "healthchecks service owner";
          isSystemUser = true;
          group = defaultUser;
        };
    };

    users.groups = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} =
        {
          members = [ defaultUser ];
        };
    };
  };
}
