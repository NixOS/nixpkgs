{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  cfg = config.services.bagage;
  defaultUser = "bagage";
  defaultGroup = defaultUser;
in
{
  options = {
    services.bagage = {
      enable = lib.mkEnableOption "bagage, a webdav bridge to S3";

      package = lib.mkPackageOption pkgs "bagage" { };

      environmentFile = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/bagage.env";
        description = lib.mdDoc ''
          An environment file as defined in {manpage}`systemd.exec(5)`.
        '';
      };

      user = lib.mkOption {
        type = types.str;
        default = defaultUser;
        example = "yourUser";
        description = lib.mdDoc ''
          The user to run bagage as.
          By default, a user named `${defaultUser}` will be created whose home
          directory is [stateDir](#opt-services.bagage.stateDir).
        '';
      };

      group = lib.mkOption {
        type = types.str;
        default = defaultGroup;
        example = "yourGroup";
        description = lib.mdDoc ''
          The group to run bagage under.
          By default, a group named `${defaultGroup}` will be created.
        '';
      };

      address = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Web interface address.";
      };

      port = lib.mkOption {
        type = types.port;
        default = 8080;
        description = "Web interface port.";
      };

      url = lib.mkOption {
        type = types.str;
        default = "https://localhost:8080";
        example = "https://some-hostname-or-ip:34567";
        description = "Web interface address.";
      };

      stateDir = lib.mkOption {
        default = "/var/lib/bagage";
        type = types.str;
        description = "bagage data directory.";
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = lib.mdDoc ''
          Extra config options.
        '';
        example = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${defaultUser} = lib.mkIf (cfg.user == defaultUser) {
      group = cfg.group;
      home = cfg.stateDir;
      isSystemUser = true;
      createHome = true;
      description = "bagage daemon user";
    };

    users.groups = lib.mkIf (cfg.group == defaultGroup) { ${defaultGroup} = { }; };

    systemd = {
      services.bagage = {
        description = "bagage";
        wantedBy = [ "multi-user.target" ];
        environment = {
          BAGAGE_HTTP_LISTEN = "0.0.0.0:7947";
          BAGAGE_WEBDAV_PREFIX = "/webdav";
          BAGAGE_LDAP_ENDPOINT = "https://ldap.bhankas.org";
          BAGAGE_LDAP_USER_BASE_DN = "dc=bhankas,dc=org";
          BAGAGE_LDAP_USERNAME_ATTR = "cn";
          BAGAGE_S3_ENDPOINT = "garage.deuxfleurs.fr";
          BAGAGE_S3_SSL = "true";
          BAGAGE_S3_CACHE = "./s3_cache";
          BAGAGE_SSH_KEY = "id_rsa";
        } // cfg.environment;
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe cfg.package} server";
          WorkingDirectory = cfg.stateDir;
          User = cfg.user;
          Group = cfg.group;
          Restart = "always";
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          ReadWritePaths = [ cfg.stateDir ];
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          SystemCallArchitectures = "native";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ bhankas ];
}
