{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lldap;
  format = pkgs.formats.toml { };

  ldapUserPassSources = lib.length (
    lib.filter (x: x) [
      (cfg.credentials ? LLDAP_LDAP_USER_PASS_FILE)
      ((cfg.environment.LLDAP_LDAP_USER_PASS or null) != null)
      ((cfg.environment.LLDAP_LDAP_USER_PASS_FILE or null) != null)
      ((cfg.settings.ldap_user_pass or null) != null)
      ((cfg.settings.ldap_user_pass_file or null) != null)
    ]
  );
  jwtSecretSources = lib.length (
    lib.filter (x: x) [
      (cfg.credentials ? LLDAP_JWT_SECRET_FILE)
      ((cfg.environment.LLDAP_JWT_SECRET or null) != null)
      ((cfg.environment.LLDAP_JWT_SECRET_FILE or null) != null)
      ((cfg.settings.jwt_secret or null) != null)
      ((cfg.settings.jwt_secret_file or null) != null)
    ]
  );
in
{
  options.services.lldap = with lib; {
    enable = mkEnableOption "lldap, a lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";

    package = mkPackageOption pkgs "lldap" { };

    credentials = mkOption {
      type = with types; attrsOf path;
      default = { };
      example = {
        LLDAP_JWT_SECRET_FILE = "/run/secrets/lldap-jwt-secret";
        LLDAP_LDAP_USER_PASS_FILE = "/run/secrets/lldap-admin-password";
        LLDAP_SMTP_OPTIONS__PASSWORD_FILE = "/run/secrets/smtp-password";
      };
      description = ''
        Environment variables with absolute paths to credential files to load
        on service startup.
      '';
    };

    environment = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = ''
        Environment variables passed to the service.
        Any config option name prefixed with `LLDAP_` takes priority over the one in the configuration file.

        See [lldap configuration docs] for more environment variables.

        [lldap configuration docs]: https://github.com/lldap/lldap/blob/main/lldap_config.docker_template.toml

        Note: When using the `credentials` option, the corresponding environment variables
        will be set automatically and should not be specified here.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.
      '';
    };

    settings = mkOption {
      description = ''
        Free-form settings written directly to the `lldap_config.toml` file.
        Refer to <https://github.com/lldap/lldap/blob/main/lldap_config.docker_template.toml> for supported values.
      '';

      default = { };

      type = types.submodule {
        freeformType = format.type;
        options = {
          ldap_host = mkOption {
            type = types.str;
            description = "The host address that the LDAP server will be bound to.";
            default = "::";
          };

          ldap_port = mkOption {
            type = types.port;
            description = "The port on which to have the LDAP server.";
            default = 3890;
          };

          http_host = mkOption {
            type = types.str;
            description = "The host address that the HTTP server will be bound to.";
            default = "::";
          };

          http_port = mkOption {
            type = types.port;
            description = "The port on which to have the HTTP server, for user login and administration.";
            default = 17170;
          };

          http_url = mkOption {
            type = types.str;
            description = "The public URL of the server, for password reset links.";
            default = "http://localhost";
          };

          ldap_base_dn = mkOption {
            type = types.str;
            description = "Base DN for LDAP.";
            example = "dc=example,dc=com";
          };

          ldap_user_dn = mkOption {
            type = types.str;
            description = "Admin username";
            default = "admin";
          };

          ldap_user_email = mkOption {
            type = types.str;
            description = "Admin email.";
            default = "admin@example.com";
          };

          database_url = mkOption {
            type = types.str;
            description = "Database URL.";
            default = "sqlite://./users.db?mode=rwc";
            example = "postgres://postgres-user:password@postgres-server/my-database";
          };

          ldap_user_pass = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Password for default admin password.

              Unsecure: Use `credentials.LLDAP_LDAP_USER_PASS_FILE` instead.
            '';
          };

          ldap_user_pass_file = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Path to a file containing the default admin password.

              If you want to update the default admin password through this setting,
              you must set `force_ldap_user_pass_reset` to `true`.
              Otherwise changing this setting will have no effect
              unless this is the very first time LLDAP is started and its database is still empty.
            '';
          };

          force_ldap_user_pass_reset = mkOption {
            type = types.oneOf [
              types.bool
              (types.enum [ "always" ])
            ];
            default = false;
            description = ''
              Force reset of the admin password.

              Set this setting to `"always"` to update the admin password when `ldap_user_pass_file` changes.
              Setting to `"always"` also means any password update in the UI will be overwritten next time the service restarts.

              The difference between `true` and `"always"` is the former is intended for a one time fix
              while the latter is intended for a declarative workflow. In practice, the result
              is the same: the password gets reset. The only practical difference is the former
              outputs a warning message while the latter outputs an info message.
            '';
          };

          jwt_secret_file = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Path to a file containing the JWT secret.
            '';
          };
        };
      };

      # TOML does not allow null values, so we use null to omit those fields
      apply = lib.filterAttrsRecursive (_: v: v != null);
    };

    silenceForceUserPassResetWarning = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable warning when the admin password is set declaratively with the `ldap_user_pass_file` setting
        but the `force_ldap_user_pass_reset` is set to `false`.

        This can lead to the admin password to drift from the one given declaratively.
        If that is okay for you and you want to silence the warning, set this option to `true`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = ldapUserPassSources <= 1;
        message = "lldap: Admin password should be configured via only one method.";
      }
      {
        assertion = jwtSecretSources <= 1;
        message = "lldap: JWT secret should be configured via only one method.";
      }
    ];

    warnings =
      lib.optionals (cfg.settings.ldap_user_pass or null != null) [
        "lldap: Using insecure `settings.ldap_user_pass`. Use `credentials.LLDAP_LDAP_USER_PASS_FILE` instead."
      ]
      ++
        lib.optionals
          (cfg.settings.force_ldap_user_pass_reset == false && cfg.silenceForceUserPassResetWarning == false)
          [
            ''
              lldap: The `force_ldap_user_pass_reset` setting is set to `false` which means
              the admin password can be changed through the UI and will drift from the one defined in your nix config.
              It also means changing the setting `ldap_user_pass` or `ldap_user_pass_file` will have no effect on the admin password.
              Either set `force_ldap_user_pass_reset` to `"always"` or silence this warning by setting the option `services.lldap.silenceForceUserPassResetWarning` to `true`.
            ''
          ];

    systemd.services.lldap = {
      description = "Lightweight LDAP server (lldap)";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      # lldap defaults to a hardcoded `jwt_secret` value if none is provided, which is bad, because
      # an attacker could create a valid admin jwt access token fairly trivially.
      # Because there are multiple ways `jwt_secret` can be provided, we check if any one of them is present,
      # and if not, bootstrap a secret in `/var/lib/lldap/jwt_secret_file` and give that to lldap.
      script =
        lib.optionalString (jwtSecretSources == 0) ''
          if [[ ! -e "./jwt_secret_file" ]]; then
            ${lib.getExe pkgs.openssl} rand -base64 -out ./jwt_secret_file 32
          fi
          export LLDAP_JWT_SECRET_FILE="./jwt_secret_file"
        ''
        + ''
          ${lib.getExe cfg.package} run --config-file ${format.generate "lldap_config.toml" cfg.settings}
        '';
      serviceConfig = {
        StateDirectory = "lldap";
        StateDirectoryMode = "0750";
        WorkingDirectory = "%S/lldap";
        UMask = "0027";
        User = "lldap";
        Group = "lldap";
        DynamicUser = true;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        Environment = lib.mapAttrsToList (name: _: "${name}=%d/${name}") cfg.credentials;
        LoadCredential = lib.mapAttrsToList (name: value: "${name}:${value}") cfg.credentials;
      };
      inherit (cfg) environment;
    };
  };
}
