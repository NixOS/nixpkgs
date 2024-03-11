{ config, lib, pkgs, utils, ... }:

let
  cfg = config.services.lldap;
  format = pkgs.formats.toml { };
in
{
  options.services.lldap = with lib; {
    enable = mkEnableOption (mdDoc "lldap");

    package = mkPackageOption pkgs "lldap" { };

    environment = mkOption {
      type = with types; attrsOf str;
      default = { };
      example = {
        LLDAP_JWT_SECRET_FILE = "/run/lldap/jwt_secret";
        LLDAP_LDAP_USER_PASS_FILE = "/run/lldap/user_password";
      };
      description = lib.mdDoc ''
        Environment variables passed to the service.
        Any config option name prefixed with `LLDAP_` takes priority over the one in the configuration file.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "lldap";
      description = lib.mdDoc ''
        User under which lldap should run (default lldap).
      '';
    };

    group = mkOption {
      type = types.str;
      default = "lldap";
      description = lib.mdDoc ''
        Group under which lldap should run (default lldap).
      '';
    };

    dynamicUser = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        System User or dynamic systemd User.
      '';
    };

    settings = mkOption {
      description = mdDoc ''
        Free-form settings written directly to the `lldap_config.toml` file.
        Refer to <https://github.com/lldap/lldap/blob/main/lldap_config.docker_template.toml> for supported values.
      '';

      default = { };

      type = types.submodule {
        freeformType = format.type;
        options = {
          ldap_host = mkOption {
            type = types.str;
            description = mdDoc "The host address that the LDAP server will be bound to.";
            default = "::";
          };

          ldap_port = mkOption {
            type = types.port;
            description = mdDoc "The port on which to have the LDAP server.";
            default = 3890;
          };

          http_host = mkOption {
            type = types.str;
            description = mdDoc "The host address that the HTTP server will be bound to.";
            default = "::";
          };

          http_port = mkOption {
            type = types.port;
            description = mdDoc "The port on which to have the HTTP server, for user login and administration.";
            default = 17170;
          };

          http_url = mkOption {
            type = types.str;
            description = mdDoc "The public URL of the server, for password reset links.";
            default = "http://localhost";
          };

          ldap_base_dn = mkOption {
            type = types.str;
            description = mdDoc "Base DN for LDAP.";
            example = "dc=example,dc=com";
          };

          ldap_user_dn = mkOption {
            type = types.str;
            description = mdDoc "Admin username";
            default = "admin";
          };

          ldap_user_email = mkOption {
            type = types.str;
            description = mdDoc "Admin email.";
            default = "admin@example.com";
          };

          database_url = mkOption {
            type = types.str;
            description = mdDoc "Database URL.";
            default = "sqlite://./users.db?mode=rwc";
            example = "postgres://postgres-user:password@postgres-server/my-database";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = lib.mkIf (! cfg.dynamicUser) {
       groups."${cfg.group}" = {};
       users."${cfg.user}" = {
           isSystemUser = true;
           group = cfg.group;
       };
    };

    systemd.services.lldap = {
      description = "Lightweight LDAP server (lldap)";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} run --config-file ${format.generate "lldap_config.toml" cfg.settings}";
        StateDirectory = "lldap";
        WorkingDirectory = "%S/lldap";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = cfg.dynamicUser;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
      };
      inherit (cfg) environment;
    };
  };
}
