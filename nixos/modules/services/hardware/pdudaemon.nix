{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.pdudaemon;
  configFile = pkgs.writeText "pdudaemon.conf" (
    lib.generators.toJSON { } {
      daemon = {
        hostname = cfg.bindAddress;
        port = cfg.port;
        logging_level = cfg.logLevel;
        listener = cfg.listener;
      };
      pdus = cfg.pdus;
    }
  );
in
{
  meta = {
    maintainers = with lib.maintainers; [
      aiyion
      emantor
    ];
  };

  options = {
    services.pdudaemon = {
      enable = lib.mkEnableOption "PDUDaemon";

      package = lib.mkPackageOption pkgs "pdudaemon" { };

      bindAddress = lib.mkOption {
        default = "0.0.0.0";
        type = lib.types.str;
        description = "Bind address for the PDUDaemon.";
      };

      port = lib.mkOption {
        default = 16421;
        type = lib.types.port;
        description = "Port to bind to.";
      };

      openFirewall = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to automatically open the PDUDaemon listen port in the firewall.
        '';
      };

      listener = lib.mkOption {
        default = "http";
        type = lib.types.enum [
          "http"
          "tcp"
        ];
        description = "Which kind of listener to provide.";
      };

      logLevel = lib.mkOption {
        default = "error";
        type = lib.types.enum [
          "debug"
          "info"
          "warning"
          "error"
        ];
        description = "PDUDaemon log level.";
      };

      pdus = lib.mkOption {
        type = with lib.types; attrsOf anything;
        default = { };
        description = ''
          Structural pdus section of PDUDaemon's pdudaemon.conf.
          Refer to <https://github.com/pdudaemon/pdudaemon/blob/main/share/pdudaemon.conf>
          for more examples.
        '';
        example = lib.literalExpression ''
          {
            cbs350-poe-switch = {
              driver = "snmpv1";
              community = "private";
              oid = ".1.3.6.1.2.1.105.1.1.1.3.1.*;
              onsetting = 1;
              offsetting = 2;
            };
            energenie = {
              driver = "EG-PMS";
              device = "aa:bb:cc:xx:yy";
            };
            local = {
              driver = "localcmdline";
            };
          };
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.pdudaemon = {
      after = [ "network-online.target" ];
      description = "Control and Queueing daemon for PDUs";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --conf ${configFile}";
        Type = "simple";
        DynamicUser = "yes";
        StateDirectory = "pdudaemon";
        ProtectHome = true;
        Restart = "on-failure";
        CapabilityBoundingSet = "";
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        RestrictNamespaces = true;
        ProtectHostname = true;
        LockPersonality = true;
        ProtectKernelTunables = true;
        RestrictRealtime = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateUsers = true;
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
