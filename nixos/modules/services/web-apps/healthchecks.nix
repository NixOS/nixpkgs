{
  config,
  lib,
  options,
  pkgs,
  buildEnv,
  ...
}:

with lib;

let
  defaultUser = "healthchecks";
  cfg = config.services.healthchecks;
  opt = options.services.healthchecks;
  pkg = cfg.package;
  boolToPython = b: if b then "True" else "False";
  environment = {
    PYTHONPATH = pkg.pythonPath;
    STATIC_ROOT = cfg.dataDir + "/static";
  } // lib.filterAttrs (_: v: !builtins.isNull v) cfg.settings;

  environmentFile = pkgs.writeText "healthchecks-environment" (
    lib.generators.toKeyValue { } environment
  );

  healthchecksManageScript = pkgs.writeShellScriptBin "healthchecks-manage" ''
    sudo=exec
    if [[ "$USER" != "${cfg.user}" ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${cfg.user} --preserve-env --preserve-env=PYTHONPATH'
    fi
    export $(cat ${environmentFile} | xargs)
    ${lib.optionalString (cfg.settingsFile != null) "export $(cat ${cfg.settingsFile} | xargs)"}
    $sudo ${pkg}/opt/healthchecks/manage.py "$@"
  '';
in
{
  options.services.healthchecks = {
    enable = mkEnableOption "healthchecks" // {
      description = ''
        Enable healthchecks.
        It is expected to be run behind a HTTP reverse proxy.
      '';
    };

    package = mkPackageOption pkgs "healthchecks" { };

    user = mkOption {
      default = defaultUser;
      type = types.str;
      description = ''
        User account under which healthchecks runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the healthchecks service starts.
        :::
      '';
    };

    group = mkOption {
      default = defaultUser;
      type = types.str;
      description = ''
        Group account under which healthchecks runs.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the healthchecks service starts.
        :::
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = "Address the server will listen on.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port the server will listen on.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/healthchecks";
      description = ''
        The directory used to store all data for healthchecks.

        ::: {.note}
        If left as the default value this directory will automatically be created before
        the healthchecks server starts, otherwise you are responsible for ensuring the
        directory exists with appropriate ownership and permissions.
        :::
      '';
    };

    settingsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = opt.settings.description;
    };

    settings = lib.mkOption {
      description = ''
        Environment variables which are read by healthchecks `(local)_settings.py`.

        Settings which are explicitly covered in options below, are type-checked and/or transformed
        before added to the environment, everything else is passed as a string.

        See <https://healthchecks.io/docs/self_hosted_configuration/>
        for a full documentation of settings.

        We add additional variables to this list inside the packages `local_settings.py.`
        - `STATIC_ROOT` to set a state directory for dynamically generated static files.
        - `SECRET_KEY_FILE` to read `SECRET_KEY` from a file at runtime and keep it out of
          /nix/store.
        - `_FILE` variants for several values that hold sensitive information in
          [Healthchecks configuration](https://healthchecks.io/docs/self_hosted_configuration/) so
          that they also can be read from a file and kept out of /nix/store. To see which values
          have support for a `_FILE` variant, run:
          - `nix-instantiate --eval --expr '(import <nixpkgs> {}).healthchecks.secrets'`
          - or `nix eval 'nixpkgs#healthchecks.secrets'` if the flake support has been enabled.

        If the same variable is set in both `settings` and `settingsFile` the value from `settingsFile` has priority.
      '';
      type = types.submodule (settings: {
        freeformType = types.attrsOf types.str;
        options = {
          ALLOWED_HOSTS = lib.mkOption {
            type = types.listOf types.str;
            default = [ "*" ];
            description = "The host/domain names that this site can serve.";
            apply = lib.concatStringsSep ",";
          };

          SECRET_KEY_FILE = mkOption {
            type = types.nullOr types.path;
            description = "Path to a file containing the secret key.";
            default = null;
          };

          DEBUG = mkOption {
            type = types.bool;
            default = false;
            description = "Enable debug mode.";
            apply = boolToPython;
          };

          REGISTRATION_OPEN = mkOption {
            type = types.bool;
            default = false;
            description = ''
              A boolean that controls whether site visitors can create new accounts.
              Set it to false if you are setting up a private Healthchecks instance,
              but it needs to be publicly accessible (so, for example, your cloud
              services can send pings to it).
              If you close new user registration, you can still selectively invite
              users to your team account.
            '';
            apply = boolToPython;
          };

          DB = mkOption {
            type = types.enum [
              "sqlite"
              "postgres"
              "mysql"
            ];
            default = "sqlite";
            description = "Database engine to use.";
          };

          DB_NAME = mkOption {
            type = types.str;
            default = if settings.config.DB == "sqlite" then "${cfg.dataDir}/healthchecks.sqlite" else "hc";
            defaultText = lib.literalExpression ''
              if config.${settings.options.DB} == "sqlite"
              then "''${config.${opt.dataDir}}/healthchecks.sqlite"
              else "hc"
            '';
            description = "Database name.";
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ healthchecksManageScript ];

    systemd.targets.healthchecks = {
      description = "Target for all Healthchecks services";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
      ];
    };

    systemd.services =
      let
        commonConfig = {
          WorkingDirectory = cfg.dataDir;
          User = cfg.user;
          Group = cfg.group;
          EnvironmentFile = [
            environmentFile
          ] ++ lib.optional (cfg.settingsFile != null) cfg.settingsFile;
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

          preStart =
            ''
              ${pkg}/opt/healthchecks/manage.py collectstatic --no-input
              ${pkg}/opt/healthchecks/manage.py remove_stale_contenttypes --no-input
            ''
            + lib.optionalString (cfg.settings.DEBUG != "True") "${pkg}/opt/healthchecks/manage.py compress";

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
      ${defaultUser} = {
        description = "healthchecks service owner";
        isSystemUser = true;
        group = defaultUser;
      };
    };

    users.groups = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        members = [ defaultUser ];
      };
    };
  };
}
