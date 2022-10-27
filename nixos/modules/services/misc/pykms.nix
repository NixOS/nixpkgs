{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.pykms;
  libDir = "/var/lib/pykms";

in
{
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  imports = [
    (mkRemovedOptionModule [ "services" "pykms" "verbose" ] "Use services.pykms.logLevel instead")
  ];

  options = {
    services.pykms = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable the PyKMS service.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc "The IP address on which to listen.";
      };

      port = mkOption {
        type = types.int;
        default = 1688;
        description = lib.mdDoc "The port on which to listen.";
      };

      openFirewallPort = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether the listening port should be opened automatically.";
      };

      memoryLimit = mkOption {
        type = types.str;
        default = "64M";
        description = lib.mdDoc "How much memory to use at most.";
      };

      logLevel = mkOption {
        type = types.enum [ "CRITICAL" "ERROR" "WARNING" "INFO" "DEBUG" "MININFO" ];
        default = "INFO";
        description = lib.mdDoc "How much to log";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc "Additional arguments";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewallPort [ cfg.port ];

    systemd.services.pykms = {
      description = "Python KMS";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # python programs with DynamicUser = true require HOME to be set
      environment.HOME = libDir;
      serviceConfig = with pkgs; {
        DynamicUser = true;
        StateDirectory = baseNameOf libDir;
        ExecStartPre = "${getBin pykms}/libexec/create_pykms_db.sh ${libDir}/clients.db";
        ExecStart = lib.concatStringsSep " " ([
          "${getBin pykms}/bin/server"
          "--logfile=STDOUT"
          "--loglevel=${cfg.logLevel}"
          "--sqlite=${libDir}/clients.db"
        ] ++ cfg.extraArgs ++ [
          cfg.listenAddress
          (toString cfg.port)
        ]);
        ProtectHome = "tmpfs";
        WorkingDirectory = libDir;
        SyslogIdentifier = "pykms";
        Restart = "on-failure";
        MemoryLimit = cfg.memoryLimit;
      };
    };
  };
}
