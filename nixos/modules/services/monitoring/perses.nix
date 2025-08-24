{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf
    types
    ;

  cfg = config.services.perses;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;

in
{
  options.services.perses = {
    enable = mkEnableOption "perses";

    package = mkPackageOption pkgs "perses" { };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        Perses Web interface port.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Address to listen on.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      description = ''
        Perses settings. See <https://perses.dev/perses/docs/configuration/configuration/> for available options.
      '';
      default = { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.perses = {
      description = "Preses Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/perses -config '${configFile}' -web.listen-address '${cfg.listenAddress}:${toString cfg.port}'";

        User = "perses";
        DynamicUser = true;
        Restart = "on-failure";
        RuntimeDirectory = "perses";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "perses";

        # Hardening
        AmbientCapabilities = lib.mkIf (cfg.port < 1024) [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = if (cfg.port < 1024) then [ "CAP_NET_BIND_SERVICE" ] else [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0027";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
