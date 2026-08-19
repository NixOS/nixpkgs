{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.labgrid.coordinator;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      aiyion
      emantor
    ];
  };

  options = {
    services.labgrid.coordinator = {
      bindAddress = lib.mkOption {
        default = "0.0.0.0";
        type = lib.types.str;
        description = "Bind address for the labgrid coordinator.";
      };

      debug = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = ''
          Whether to enable debug mode.
        '';
      };

      enable = lib.mkEnableOption "Labgrid Coordinator";

      openFirewall = lib.mkOption {
        default = false;
        type = with lib.types; bool;
        description = ''
          Whether to automatically open the coordinator listen port in the firewall.
        '';
      };

      package = lib.mkPackageOption pkgs [ "python3Packages" "labgrid" ] { };

      port = lib.mkOption {
        default = 20408;
        type = lib.types.port;
        description = "Coordinator port to bind to.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.labgrid-coordinator = {
      after = [ "network-online.target" ];
      description = "Labgrid Coordinator";
      serviceConfig = {
        Environment = ''"PYTHONUNBUFFERED=1"'';
        ExecStart = "${lib.getBin cfg.package}/bin/labgrid-coordinator ${lib.optionalString cfg.debug "--debug"} --listen ${cfg.bindAddress}:${toString cfg.port}";
        Restart = "on-failure";
        DynamicUser = "yes";
        StateDirectory = "labgrid-coordinator";
        WorkingDirectory = "/var/lib/labgrid-coordinator";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictRealtime = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
      };
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
