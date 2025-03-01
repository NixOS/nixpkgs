{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.glance;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    getExe
    types
    ;

  settingsFormat = pkgs.formats.yaml { };
in
{
  options.services.glance = {
    enable = mkEnableOption "glance";
    package = mkPackageOption pkgs "glance" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          server = {
            host = mkOption {
              description = "Glance bind address";
              default = "127.0.0.1";
              example = "0.0.0.0";
              type = types.str;
            };
            port = mkOption {
              description = "Glance port to listen on";
              default = 8080;
              example = 5678;
              type = types.port;
            };
          };
          pages = mkOption {
            type = settingsFormat.type;
            description = ''
              List of pages to be present on the dashboard.

              See <https://github.com/glanceapp/glance/blob/main/docs/configuration.md#pages--columns>
            '';
            default = [
              {
                name = "Calendar";
                columns = [
                  {
                    size = "full";
                    widgets = [ { type = "calendar"; } ];
                  }
                ];
              }
            ];
            example = [
              {
                name = "Home";
                columns = [
                  {
                    size = "full";
                    widgets = [
                      { type = "calendar"; }
                      {
                        type = "weather";
                        location = "Nivelles, Belgium";
                      }
                    ];
                  }
                ];
              }
            ];
          };
        };
      };
      default = { };
      description = ''
        Configuration written to a yaml file that is read by glance. See
        <https://github.com/glanceapp/glance/blob/main/docs/configuration.md>
        for more.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for Glance.
        This adds `services.glance.settings.server.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.glance = {
      description = "Glance feed dashboard server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart =
          let
            glance-yaml = settingsFormat.generate "glance.yaml" cfg.settings;
          in
          "${getExe cfg.package} --config ${glance-yaml}";
        WorkingDirectory = "/var/lib/glance";
        StateDirectory = "glance";
        RuntimeDirectory = "glance";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DynamicUser = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.server.port ]; };
  };

  meta.doc = ./glance.md;
  meta.maintainers = [ lib.maintainers.drupol ];
}
