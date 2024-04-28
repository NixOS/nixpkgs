{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.hysteria;
  settingsFormat = pkgs.formats.json { };
in
{
  options.services.hysteria = {
    enable = lib.mkEnableOption "Hysteria, a powerful, lightning fast and censorship resistant proxy";

    package = lib.mkPackageOption pkgs "hysteria" { };

    mode = lib.mkOption {
      type = lib.types.enum [
        "server"
        "client"
      ];
      default = "server";
      description = "Whether to use Hysteria as a client or a server.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      description = ''
        The Hysteria configuration, see https://hysteria.network/ for documentation.

        Options containing secret data should be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.hysteria = {
      description = "Hysteria daemon, a powerful, lightning fast and censorship resistant proxy.";
      documentation = [ "https://hysteria.network/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      preStart = utils.genJqSecretsReplacementSnippet cfg.settings "/run/hysteria/config.json";
      serviceConfig = {
        ExecStart = lib.concatStringsSep " " [
          (lib.getExe cfg.package)
          cfg.mode
          "--config /run/hysteria/config.json"
        ];

        DynamicUser = true;
        RuntimeDirectory = "hysteria";

        ### Hardening
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ Guanran928 ];
}
