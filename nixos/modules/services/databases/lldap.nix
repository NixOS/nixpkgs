{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lldap;
  format = pkgs.formats.toml { };

  inherit (lib) mkOption types;

  ensureFormat = pkgs.formats.json { };
  ensureGenerate =
    name: source: ensureFormat.generate name (lib.filterAttrsRecursive (n: v: v != null) source);

  ensureFieldsOptions = name: {
    name = mkOption {
      type = types.str;
      description = "Name of the field.";
      default = name;
    };

    attributeType = mkOption {
      type = types.enum [
        "STRING"
        "INTEGER"
        "JPEG"
        "DATE_TIME"
      ];
      description = "Attribute type.";
    };

    isEditable = mkOption {
      type = types.bool;
      description = "Is field editable.";
      default = true;
    };

    isList = mkOption {
      type = types.bool;
      description = "Is field a list.";
      default = false;
    };

    isVisible = mkOption {
      type = types.bool;
      description = "Is field visible in UI.";
      default = true;
    };
  };

  allUserGroups = lib.flatten (lib.mapAttrsToList (n: u: u.groups) cfg.ensureUsers);
  # The three hardcoded groups are always created when the service starts.
  allGroups = lib.mapAttrsToList (n: g: g.name) cfg.ensureGroups ++ [
    "lldap_admin"
    "lldap_password_manager"
    "lldap_strict_readonly"
  ];
  userGroupNotInEnsuredGroup = lib.sortOn lib.id (
    lib.unique (lib.subtractLists allGroups allUserGroups)
  );
  someUsersBelongToNonEnsuredGroup = (lib.lists.length userGroupNotInEnsuredGroup) > 0;

  generateEnsureConfigDir =
    name: source:
    let
      genOne =
        name: sourceOne:
        pkgs.writeTextDir "configs/${name}.json" (
          builtins.readFile (ensureGenerate "configs/${name}.json" sourceOne)
        );
    in
    "${
      pkgs.symlinkJoin {
        inherit name;
        paths = lib.mapAttrsToList genOne source;
      }
    }/configs";
in
{
  options.services.lldap = with lib; {
    enable = mkEnableOption "lldap, a lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";

    package = mkPackageOption pkgs "lldap" { };

    bootstrap-package = mkPackageOption pkgs "lldap-bootstrap" { };

    environment = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = {
        LLDAP_JWT_SECRET_FILE = "/run/lldap/jwt_secret";
        LLDAP_LDAP_USER_PASS_FILE = "/run/lldap/user_password";
      };
      description = ''
        Environment variables passed to the service.
        Any config option name prefixed with `LLDAP_` takes priority over the one in the configuration file.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.
      '';
    };

    adminPasswordFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to a file containing the default admin password.
      '';
    };

    resetAdminPassword = mkOption {
      type = types.nullOr (
        types.oneOf [
          types.bool
          (types.enum [ "always" ])
        ]
      );
      default = false;
      description = ''
        Force reset of the admin password.

        Break glass in case of emergency: if you lost the admin password, you
        can set this to true to force a reset of the admin password to the value
        of `adminPasswordFile`.

        Alternatively, you can set it to `"always"` to reset every time the server starts
        which makes for a more declarative configuration.

        The difference between `true` and `"always"` is the former is intended for a one time fix
        while the latter is intended for a declarative workflow. In practice, the result
        is the same: the password gets reset. The only practical difference is the former
        outputs a warning message while the latter outputs an info message.
      '';
    };

    jwtSecretFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to a file containing the default admin password.
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
        };
      };
    };

    ensureUsers = mkOption {
      description = ''
        Create the users defined here on service startup.

        If `enforceEnsure` option is `true`, the groups
        users belong to must be present in the `ensureGroups` option.

        Non-default options must be added to the `ensureGroupFields` option.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            freeformType = ensureFormat.type;

            options = {
              id = mkOption {
                type = types.str;
                description = "Username.";
                default = name;
              };

              email = mkOption {
                type = types.str;
                description = "Email.";
              };

              password_file = mkOption {
                type = types.str;
                description = "File containing the password.";
              };

              displayName = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Display name.";
              };

              firstName = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "First name.";
              };

              lastName = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Last name.";
              };

              avatar_file = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Avatar file. Must be a valid path to jpeg file (ignored if avatar_url specified)";
              };

              avatar_url = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Avatar url. must be a valid URL to jpeg file (ignored if gravatar_avatar specified)";
              };

              gravatar_avatar = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Get avatar from Gravatar using the email.";
              };

              weser_avatar = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Convert avatar retrieved by gravatar or the URL.";
              };

              groups = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Groups the user would be a member of (all the groups must be specified in group config files).";
              };
            };
          }
        )
      );
    };

    ensureGroups = mkOption {
      description = ''
        Create the groups defined here on service startup.

        Non-default options must be added to the `ensureGroupFields` option.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            freeformType = ensureFormat.type;

            options = {
              name = mkOption {
                type = types.str;
                description = "Name of the group.";
                default = name;
              };
            };
          }
        )
      );
    };

    ensureUserFields = mkOption {
      description = "Extra fields for users";
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = ensureFieldsOptions name;
          }
        )
      );
    };

    ensureGroupFields = mkOption {
      description = "Extra fields for groups";
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = ensureFieldsOptions name;
          }
        )
      );
    };

    ensureAdminUsername = mkOption {
      type = types.str;
      default = "admin";
      description = ''
        Username of an admin user with which to connect to the LLDAP service.

        By default, it is the default admin username `admin`.
        If using another user, it must be managed manually.
      '';
    };

    ensureAdminPasswordFile = mkOption {
      type = types.nullOr types.str;
      defaultText = "config.services.lldap.adminPasswordFile";
      default = cfg.adminPasswordFile;
      description = ''
        Path to the file containing the password of an admin user with which to connect to the LLDAP service.

        By default, it is the same as the password for the default admin user 'admin'.
        If using a password from another user, it must be managed manually.
      '';
    };

    enforceEnsure = mkOption {
      description = "Delete users, groups and fields not in their respective ensure options and remove users from groups they do not belong to.";
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.adminPasswordFile == null || cfg.resetAdminPassword != false;
        message = ''
          The default admin password is set declaratively with `adminPasswordFile` option but the `resetAdminPassword` is set to `false`.
          This means the admin password can be changed through the UI and will drift from the one defined in your nix config.
          Please set the `resetAdminPassword` option to `true` or `"always"`.
        '';
      }
      {
        assertion =
          cfg.ensureUsers != { }
          || cfg.ensureGroups != { }
          || cfg.ensureUserFields != { }
          || cfg.ensureGroupFields != { }
          || cfg.enforceEnsure
          -> cfg.ensureAdminPasswordFile != null;
        message = ''
          Some ensure options are set but no admin user password is set.
          Add a default password to `adminPasswordFile` to manage the admin user declaratively
          or create a user manually and set its password in `ensureAdminPasswordFile`.
        '';
      }
      {
        assertion = cfg.enforceEnsure -> !someUsersBelongToNonEnsuredGroup;
        message = ''
          Some users belong to groups not present in the ensureGroups attr,
          add the following groups or remove them from the groups a user belong to:
            ${lib.concatStringsSep ", " (map (x: "\"${x}\"") userGroupNotInEnsuredGroup)}
        '';
      }
    ];

    warnings = (
      lib.optionals (!cfg.enforceEnsure && (lib.debug.traceValSeq someUsersBelongToNonEnsuredGroup)) [
        ''
          Some users belong to groups not managed by the configuration here,
          make sure the following groups exist or the service will not start properly:
            ${lib.concatStringsSep ", " (map (x: "\"${x}\"") userGroupNotInEnsuredGroup)}
        ''
      ]
    );

    services.lldap.environment = {
      LLDAP_JWT_SECRET_FILE = lib.mkIf (cfg.jwtSecretFile != null) cfg.jwtSecretFile;
      LLDAP_LDAP_USER_PASS_FILE = lib.mkIf (cfg.adminPasswordFile != null) cfg.adminPasswordFile;
      LLDAP_FORCE_LDAP_USER_PASS_RESET =
        if builtins.isString cfg.resetAdminPassword then
          cfg.resetAdminPassword
        else if cfg.resetAdminPassword then
          "true"
        else
          "false";
    };

    systemd.services.lldap = {
      description = "Lightweight LDAP server (lldap)";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      # lldap defaults to a hardcoded `jwt_secret` value if none is provided, which is bad, because
      # an attacker could create a valid admin jwt access token fairly trivially.
      # Because there are 3 different ways `jwt_secret` can be provided, we check if any one of them is present,
      # and if not, bootstrap a secret in `/var/lib/lldap/jwt_secret_file` and give that to lldap.
      script =
        lib.optionalString (!cfg.settings ? jwt_secret) ''
          if [[ -z "$LLDAP_JWT_SECRET_FILE" ]] && [[ -z "$LLDAP_JWT_SECRET" ]]; then
            if [[ ! -e "./jwt_secret_file" ]]; then
              ${lib.getExe pkgs.openssl} rand -base64 -out ./jwt_secret_file 32
            fi
            export LLDAP_JWT_SECRET_FILE="./jwt_secret_file"
          fi
        ''
        + ''
          ${lib.getExe cfg.package} run --config-file ${format.generate "lldap_config.toml" cfg.settings}
        '';
      postStart = ''
        export LLDAP_URL=http://127.0.0.1:${toString cfg.settings.http_port}
        export LLDAP_ADMIN_USERNAME=${cfg.ensureAdminUsername}
        export LLDAP_ADMIN_PASSWORD_FILE=${cfg.ensureAdminPasswordFile}
        export USER_CONFIGS_DIR=${generateEnsureConfigDir "users" cfg.ensureUsers}
        export GROUP_CONFIGS_DIR=${generateEnsureConfigDir "groups" cfg.ensureGroups}
        export USER_SCHEMAS_DIR=${generateEnsureConfigDir "userFields" cfg.ensureUserFields}
        export GROUP_SCHEMAS_DIR=${generateEnsureConfigDir "groupFields" cfg.ensureGroupFields}
        export DO_CLEANUP=${if cfg.enforceEnsure then "true" else "false"}
        ${lib.getExe cfg.bootstrap-package}
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
      };
      inherit (cfg) environment;
    };
  };
}
