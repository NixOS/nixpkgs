{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pgadmin;
  inherit (lib.types) int bool str oneOf listOf attrsOf port path nullOr;
  inherit (lib) mkEnableOption mkOption mkPackageOption mkDefault mkForce mkIf mapAttrsToList concatStringsSep optional optionalAttrs optionalString escapeShellArg;

  _base = [ int bool str ];
  base = oneOf ([ (listOf (oneOf _base)) (attrsOf (oneOf _base)) ] ++ _base);

  formatAttrset = attr:
    "{${concatStringsSep "\n" (mapAttrsToList (key: value: "${builtins.toJSON key}: ${formatPyValue value},") attr)}}";

  formatPyValue = value:
    if builtins.isString value then builtins.toJSON value
    else if value ? _expr then value._expr
    else if builtins.isInt value then toString value
    else if builtins.isBool value then (if value then "True" else "False")
    else if builtins.isAttrs value then (formatAttrset value)
    else if builtins.isList value then "[${concatStringsSep "\n" (map (v: "${formatPyValue v},") value)}]"
    else throw "Unrecognized type";

  formatPy = attrs:
    concatStringsSep "\n" (mapAttrsToList (key: value: "${key} = ${formatPyValue value}") attrs);

  pyType = attrsOf (oneOf [ (attrsOf base) (listOf base) base ]);
in
{
  options.services.pgadmin = {
    enable = mkEnableOption "PostgreSQL Admin 4";

    port = mkOption {
      description = "Port for pgadmin4 to run on";
      type = port;
      default = 5050;
    };

    package = mkPackageOption pkgs "pgadmin4" { };

    initialEmail = mkOption {
      description = "Initial email for the pgAdmin account";
      type = str;
    };

    initialPasswordFile = mkOption {
      description = ''
        Initial password file for the pgAdmin account. Minimum length by default is 6.
        Please see `services.pgadmin.minimumPasswordLength`.
        NOTE: Should be string not a store path, to prevent the password from being world readable
      '';
      type = path;
    };

    minimumPasswordLength = mkOption {
      description = "Minimum length of the password";
      type = int;
      default = 6;
    };

    emailServer = {
      enable = mkOption {
        description = ''
          Enable SMTP email server. This is necessary, if you want to use password recovery or change your own password
        '';
        type = bool;
        default = false;
      };
      address = mkOption {
        description = "SMTP server for email delivery";
        type = str;
        default = "localhost";
      };
      port = mkOption {
        description = "SMTP server port for email delivery";
        type = port;
        default = 25;
      };
      useSSL = mkOption {
        description = "SMTP server should use SSL";
        type = bool;
        default = false;
      };
      useTLS = mkOption {
        description = "SMTP server should use TLS";
        type = bool;
        default = false;
      };
      username = mkOption {
        description = "SMTP server username for email delivery";
        type = nullOr str;
        default = null;
      };
      sender = mkOption {
        description = ''
          SMTP server sender email for email delivery. Some servers require this to be a valid email address from that server
        '';
        type = str;
        example = "noreply@example.com";
      };
      passwordFile = mkOption {
        description = ''
          Password for SMTP email account.
          NOTE: Should be string not a store path, to prevent the password from being world readable
        '';
        type = path;
      };
    };

    openFirewall = mkEnableOption "firewall passthrough for pgadmin4";

    settings = mkOption {
      description = ''
        Settings for pgadmin4.
        [Documentation](https://www.pgadmin.org/docs/pgadmin4/development/config_py.html)
      '';
      type = pyType;
      default = { };
    };
    user = mkOption {
      default = "pgadmin";
      type = str;
      description = ''
        Group under which pgadmin runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the pgadmin service starts.
        :::
      '';
    };

    group = mkOption {
      default = "pgadmin";
      type = str;
      description = ''
        Primary group under which pgadmin runs.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the pgadmin service starts.
        :::
      '';
    };
  };

  config = mkIf (cfg.enable) {
    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall) [ cfg.port ];

    services.pgadmin.settings = {
      DEFAULT_SERVER_PORT = cfg.port;
      PASSWORD_LENGTH_MIN = cfg.minimumPasswordLength;
      SERVER_MODE = true;
      UPGRADE_CHECK_ENABLED = false;
    } // (optionalAttrs cfg.openFirewall {
      DEFAULT_SERVER = mkDefault "::";
    }) // (optionalAttrs cfg.emailServer.enable {
      MAIL_SERVER = cfg.emailServer.address;
      MAIL_PORT = cfg.emailServer.port;
      MAIL_USE_SSL = cfg.emailServer.useSSL;
      MAIL_USE_TLS = cfg.emailServer.useTLS;
      MAIL_USERNAME = cfg.emailServer.username;
      SECURITY_EMAIL_SENDER = cfg.emailServer.sender;
    });

    systemd.services.pgadmin = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      requires = [ "network.target" ];
      # we're adding this optionally so just in case there's any race it'll be caught
      # in case postgres doesn't start, pgadmin will just start normally
      wants = [ "postgresql.service" ];

      path = [ config.services.postgresql.package pkgs.coreutils pkgs.bash ];

      preStart = ''
        # NOTE: this is idempotent (aka running it twice has no effect)
        # Check here for password length to prevent pgadmin from starting
        # and presenting a hard to find error message
        # see https://github.com/NixOS/nixpkgs/issues/270624
        PW_FILE="$CREDENTIALS_DIRECTORY/initial_password"
        PW_LENGTH=$(wc -m < "$PW_FILE")
        if [ $PW_LENGTH -lt ${toString cfg.minimumPasswordLength} ]; then
            echo "Password must be at least ${toString cfg.minimumPasswordLength} characters long"
            exit 1
        fi
        (
          # Email address:
          echo ${escapeShellArg cfg.initialEmail}

          # file might not contain newline. echo hack fixes that.
          PW=$(cat "$PW_FILE")

          # Password:
          echo "$PW"
          # Retype password:
          echo "$PW"
        ) | ${cfg.package}/bin/pgadmin4-cli setup-db
      '';

      restartTriggers = [
        "/etc/pgadmin/config_system.py"
      ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = mkIf (cfg.user == "pgadmin" && cfg.group == "pgadmin") true;
        LogsDirectory = "pgadmin";
        StateDirectory = "pgadmin";
        ExecStart = "${cfg.package}/bin/pgadmin4";
        LoadCredential = [ "initial_password:${cfg.initialPasswordFile}" ]
          ++ optional cfg.emailServer.enable "email_password:${cfg.emailServer.passwordFile}";
      };
    };

    users.users = mkIf (cfg.user == "pgadmin") {
      pgadmin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "pgadmin") { pgadmin = { }; };

    environment.etc."pgadmin/config_system.py" = {
      text = optionalString cfg.emailServer.enable ''
        import os
        with open(os.path.join(os.environ['CREDENTIALS_DIRECTORY'], 'email_password')) as f:
          pw = f.read()
        MAIL_PASSWORD = pw
      '' + formatPy cfg.settings;
      mode = "0600";
      user = cfg.user;
      group = cfg.group;
    };
  };
}
