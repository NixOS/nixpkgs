{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.filebrowser;
  inherit (lib) types;
  format = pkgs.formats.json { };
in
{
  options = {
    services.filebrowser = {
      enable = lib.mkEnableOption "FileBrowser";

      package = lib.mkPackageOption pkgs "filebrowser" { };

      openFirewall = lib.mkEnableOption "opening firewall ports for FileBrowser";

      settings = lib.mkOption {
        default = { };
        description = ''
          Settings for FileBrowser.
          Refer to <https://filebrowser.org/cli/filebrowser#options> for all supported values.
        '';
        type = types.submodule {
          freeformType = format.type;

          options = {
            address = lib.mkOption {
              default = "localhost";
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

            root = lib.mkOption {
              default = "/var/lib/filebrowser/data";
              description = ''
                The directory where FileBrowser stores files.
              '';
              type = types.path;
            };

            database = lib.mkOption {
              default = "/var/lib/filebrowser/database.db";
              description = ''
                The path to FileBrowser's Bolt database.
              '';
              type = types.path;
            };

            cache-dir = lib.mkOption {
              default = "/var/cache/filebrowser";
              description = ''
                The directory where FileBrowser stores its cache.
              '';
              type = types.path;
              readOnly = true;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.filebrowser = {
        after = [ "network.target" ];
        description = "FileBrowser";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart =
            let
              args = [
                (lib.getExe cfg.package)
                "--config"
                (format.generate "config.json" cfg.settings)
              ];
            in
            utils.escapeSystemdExecArgs args;

          StateDirectory = "filebrowser";
          CacheDirectory = "filebrowser";
          WorkingDirectory = cfg.settings.root;

          DynamicUser = true;

          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          DevicePolicy = "closed";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };

      tmpfiles.settings.filebrowser =
        lib.genAttrs
          [
            cfg.settings.root
            (builtins.dirOf cfg.settings.database)
          ]
          (_: {
            d.mode = "0700";
          });
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];
  };

  meta.maintainers = [
    lib.maintainers.lukaswrz
  ];
}
