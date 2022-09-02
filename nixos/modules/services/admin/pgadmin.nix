{ config, lib, pkgs, ... }:

with lib;

let
  pkg = pkgs.pgadmin4;
  cfg = config.services.pgadmin;

  _base = with types; [ int bool str ];
  base = with types; oneOf ([ (listOf (oneOf _base)) (attrsOf (oneOf _base)) ] ++ _base);

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

  pyType = with types; attrsOf (oneOf [ (attrsOf base) (listOf base) base ]);
in
{
  options.services.pgadmin = {
    enable = mkEnableOption (lib.mdDoc "PostgreSQL Admin 4");

    port = mkOption {
      description = lib.mdDoc "Port for pgadmin4 to run on";
      type = types.port;
      default = 5050;
    };

    initialEmail = mkOption {
      description = lib.mdDoc "Initial email for the pgAdmin account.";
      type = types.str;
    };

    initialPasswordFile = mkOption {
      description = lib.mdDoc ''
        Initial password file for the pgAdmin account.
        NOTE: Should be string not a store path, to prevent the password from being world readable.
      '';
      type = types.path;
    };

    openFirewall = mkEnableOption (lib.mdDoc "firewall passthrough for pgadmin4");

    settings = mkOption {
      description = lib.mdDoc ''
        Settings for pgadmin4.
        [Documentation](https://www.pgadmin.org/docs/pgadmin4/development/config_py.html).
      '';
      type = pyType;
      default= {};
    };
  };

  config = mkIf (cfg.enable) {
    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall) [ cfg.port ];

    services.pgadmin.settings = {
      DEFAULT_SERVER_PORT = cfg.port;
      SERVER_MODE = true;
    } // (optionalAttrs cfg.openFirewall {
      DEFAULT_SERVER = mkDefault "::";
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
        (
          # Email address:
          echo ${escapeShellArg cfg.initialEmail}

          # file might not contain newline. echo hack fixes that.
          PW=$(cat ${escapeShellArg cfg.initialPasswordFile})

          # Password:
          echo "$PW"
          # Retype password:
          echo "$PW"
        ) | ${pkg}/bin/pgadmin4-setup
      '';

      restartTriggers = [
        "/etc/pgadmin/config_system.py"
      ];

      serviceConfig = {
        User = "pgadmin";
        DynamicUser = true;
        LogsDirectory = "pgadmin";
        StateDirectory = "pgadmin";
        ExecStart = "${pkg}/bin/pgadmin4";
      };
    };

    users.users.pgadmin = {
      isSystemUser = true;
      group = "pgadmin";
    };

    users.groups.pgadmin = {};

    environment.etc."pgadmin/config_system.py" = {
      text = formatPy cfg.settings;
      mode = "0600";
      user = "pgadmin";
      group = "pgadmin";
    };
  };
}
