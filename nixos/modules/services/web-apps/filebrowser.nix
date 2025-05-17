{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.filebrowser;
  inherit (lib) types;
  format = pkgs.formats.json { };
  defaultUser = "filebrowser";
  defaultGroup = "filebrowser";
in
{
  options = {
    services.filebrowser = {
      enable = lib.mkEnableOption "FileBrowser";

      package = lib.mkPackageOption pkgs "filebrowser" { };

      user = lib.mkOption {
        type = types.str;
        default = defaultUser;
        description = ''
          The name of the user account under which FileBrowser should run.
        '';
      };

      group = lib.mkOption {
        type = types.str;
        default = defaultGroup;
        description = ''
          The name of an existing user group under which FileBrowser should run.
        '';
      };

      openFirewall = lib.mkOption {
        default = false;
        description = ''
          Whether to automatically open the ports for FileBrowser in the firewall.
        '';
        type = types.bool;
      };

      settings = lib.mkOption {
        default = { };
        description = ''
          Settings for FileBrowser.
          Refer to <https://filebrowser.org/cli/filebrowser-config-set> for supported values.
        '';
        type = types.submodule {
          freeformType = format.type;
          options = {
            address = lib.mkOption {
              default = "0.0.0.0";
              description = ''
                The address to listen on.
              '';
              type = types.str;
            };
            port = lib.mkOption {
              default = 8080;
              description = ''
                The port to listen on.
              '';
              type = types.port;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.filebrowser = {
      after = [ "network.target" ];
      description = "FileBrowser";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config ${format.generate "config.json" cfg.settings}";

        User = cfg.user;
        Group = cfg.group;

        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        StateDirectory = "filebrowser";
      };
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];
    users = {
      users.${cfg.user} = lib.mkIf (cfg.user == defaultUser) {
        group = cfg.group;
        isSystemUser = true;
      };
      groups.${cfg.group} = lib.mkIf (cfg.group == defaultGroup) { };
    };
  };

  meta.maintainers = [
    lib.maintainers.lukaswrz
  ];
}
