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

    host = lib.mkOption {
      description = "Glance bind address";
      default = "127.0.0.1";
      type = types.str;
    };

    port = lib.mkOption {
      description = "Glance port to listen on";
      default = 8080;
      type = types.port;
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = {
        pages = [
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
      };
      example = {
        pages = [
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
      description = ''
        Configuration written to a yaml file that is read by glance. See
        <https://github.com/glanceapp/glance/blob/main/docs/configuration.md>
        for more.
      '';
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for Glance.
        This adds `services.glance.port` to `networking.firewall.allowedTCPPorts`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.glance = {
      description = "Glance feed dashboard server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart =
          let
            glance-yaml = "${settingsFormat.generate "glance.yaml" (
              lib.recursiveUpdate cfg.settings {
                server.host = cfg.host;
                server.port = cfg.port;
              }
            )}";
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

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.doc = ./glance.md;
  meta.maintainers = [ lib.maintainers.drupol ];
}
