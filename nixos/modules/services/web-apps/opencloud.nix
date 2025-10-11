{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  cfg = config.services.opencloud;

  defaultUser = "opencloud";
  defaultGroup = defaultUser;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options = {
    services.opencloud = {
      enable = lib.mkEnableOption "OpenCloud";

      package = lib.mkPackageOption pkgs "opencloud" { };
      webPackage = lib.mkPackageOption pkgs [ "opencloud" "web" ] { };
      idpWebPackage = lib.mkPackageOption pkgs [ "opencloud" "idp-web" ] { };

      user = lib.mkOption {
        type = types.str;
        default = defaultUser;
        example = "mycloud";
        description = ''
          The user to run OpenCloud as.
          By default, a user named `${defaultUser}` will be created whose home
          directory is [](#opt-services.opencloud.stateDir).
        '';
      };

      group = lib.mkOption {
        type = types.str;
        default = defaultGroup;
        example = "mycloud";
        description = ''
          The group to run OpenCloud under.
          By default, a group named `${defaultGroup}` will be created.
        '';
      };

      address = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Web server bind address.";
      };

      port = lib.mkOption {
        type = types.port;
        default = 9200;
        description = "Web server port.";
      };

      url = lib.mkOption {
        type = types.str;
        default = "https://localhost:9200";
        example = "https://cloud.example.com";
        description = "Web interface root public URL, including scheme and port (if non-default).";
      };

      stateDir = lib.mkOption {
        default = "/var/lib/opencloud";
        type = types.path;
        description = "OpenCloud data directory.";
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf settingsFormat.type;
        default = { };
        description = ''
          Additional YAML configuration for OpenCloud services.

          Every item in this attrset will be mapped to a .yaml file in /etc/opencloud.

          The possible config options are currently not well documented, see source code:
          https://github.com/opencloud-eu/opencloud/blob/main/pkg/config/config.go
        '';

        example = {
          proxy = {
            auto_provision_accounts = true;
            oidc.rewrite_well_known = true;
            role_assignment = {
              driver = "oidc";
              oidc_role_mapper.role_claim = "opencloud_roles";
            };
          };
          web.web.config.oidc.scope = "openid profile email opencloud_roles";
        };
      };

      environmentFile = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/opencloud.env";
        description = ''
          An environment file as defined in {manpage}`systemd.exec(5)`.

          Use this to inject secrets, e.g. database or auth credentials out of band.

          Configuration provided here will override `settings` and `environment`.
        '';
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = {
          OC_INSECURE = "true";
        };
        description = ''
          Extra environment variables to set for the service.

          Use this to set configuration that may affect multiple microservices.

          Set `OC_INSECURE = "false"` if you want OpenCloud to terminate TLS.

          Configuration provided here will override `settings`.
        '';
        example = {
          OC_INSECURE = "false";
          OC_LOG_LEVEL = "error";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${defaultUser} = lib.mkIf (cfg.user == defaultUser) {
      group = cfg.group;
      home = cfg.stateDir;
      isSystemUser = true;
      createHome = true;
      description = "OpenCloud daemon user";
    };

    users.groups = lib.mkIf (cfg.group == defaultGroup) { ${defaultGroup} = { }; };

    systemd = {
      services =
        let
          environment = {
            PROXY_HTTP_ADDR = "${cfg.address}:${toString cfg.port}";
            OC_URL = cfg.url;
            OC_BASE_DATA_PATH = cfg.stateDir;
            WEB_ASSET_CORE_PATH = "${cfg.webPackage}";
            IDP_ASSET_PATH = "${cfg.idpWebPackage}/assets";
            OC_CONFIG_DIR = "/etc/opencloud";
          }
          // cfg.environment;
          commonServiceConfig = {
            EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
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
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            LockPersonality = true;
            SystemCallArchitectures = "native";
          };
        in
        {
          opencloud-init-config = lib.mkIf (cfg.settings.opencloud or { } == { }) {
            description = "Provision initial OpenCloud config";
            before = [ "opencloud.service" ];
            wantedBy = [ "multi-user.target" ];

            inherit environment;

            serviceConfig = {
              Type = "oneshot";
              ReadWritePaths = [ "/etc/opencloud" ];
            }
            // commonServiceConfig;

            path = [ cfg.package ];
            script = ''
              set -x
              config="''${OC_CONFIG_DIR}/opencloud.yaml"
              if [ ! -e "$config" ]; then
                echo "Provisioning initial OpenCloud config..."
                opencloud init --insecure "''${OC_INSECURE:false}" --config-path "''${OC_CONFIG_DIR}"
                chown ${cfg.user}:${cfg.group} "$config"
              fi
            '';
          };

          opencloud = {
            description = "OpenCloud - a secure and private way to store, access, and share your files";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            inherit environment;

            serviceConfig = {
              Type = "simple";
              ExecStart = "${lib.getExe cfg.package} server";
              WorkingDirectory = cfg.stateDir;
              User = cfg.user;
              Group = cfg.group;
              Restart = "always";
              ReadWritePaths = [ cfg.stateDir ];
            }
            // commonServiceConfig;

            restartTriggers = lib.mapAttrsToList (
              name: _: config.environment.etc."opencloud/${name}.yaml".source
            ) cfg.settings;
          };
        };
    };

    systemd.tmpfiles.settings."10-opencloud" = {
      ${cfg.stateDir}.d = {
        inherit (cfg) user group;
        mode = "0750";
      };
      "${cfg.stateDir}/idm".d = {
        inherit (cfg) user group;
        mode = "0750";
      };
    };

    environment.etc =
      (lib.mapAttrs' (name: value: {
        name = "opencloud/${name}.yaml";
        value.source = settingsFormat.generate "${name}.yaml" value;
      }) cfg.settings)
      // {
        # ensure /etc/opencloud gets created, so we can provision the config
        "opencloud/.keep".text = "";
      };
  };

  meta = {
    doc = ./opencloud.md;
    maintainers = with lib.maintainers; [
      christoph-heiss
      k900
    ];
  };
}
