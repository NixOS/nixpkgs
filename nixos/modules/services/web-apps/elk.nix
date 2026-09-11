{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    boolToString
    isBool
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.elk;
in
{
  options.services.elk = {
    enable = mkEnableOption "Elk, a nimble Mastodon web client";

    package = mkPackageOption pkgs "elk" { };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    settings = mkOption {
      default = { };
      description = ''
        Environment variables for the Elk server process, see
        <https://github.com/elk-zone/elk/blob/main/nuxt.config.ts>
        for supported keys.
      '';
      type = types.submodule {
        freeformType =
          with types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {
          HOST = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The address to listen on.";
          };

          PORT = mkOption {
            type = types.port;
            default = 3000;
            description = "The port to listen on.";
          };
        };
      };
      example = {
        PORT = 3000;
        NUXT_PUBLIC_DEFAULT_SERVER = "mastodon.social";
      };
    };
  };

  config = mkIf cfg.enable {
    services.elk.settings.NUXT_STORAGE_FS_BASE = lib.mkDefault "/var/lib/elk";

    systemd.services.elk = {
      environment = mapAttrs (_: v: if isBool v then boolToString v else toString v) cfg.settings;

      description = "Elk, a nimble Mastodon web client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        StateDirectory = "elk";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;
        DynamicUser = true;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.PORT ];
  };

  meta.maintainers = with lib.maintainers; [ onny ];
}
