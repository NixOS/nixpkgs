{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.icecream.daemon;
in
{

  ###### interface

  options = {

    services.icecream.daemon = {

      enable = lib.mkEnableOption "Icecream Daemon";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to automatically open receive port in the firewall.
        '';
      };

      openBroadcast = lib.mkOption {
        type = lib.types.bool;
        description = ''
          Whether to automatically open the firewall for scheduler discovery.
        '';
      };

      cacheLimit = lib.mkOption {
        type = lib.types.ints.u16;
        default = 256;
        description = ''
          Maximum size in Megabytes of cache used to store compile environments of compile clients.
        '';
      };

      netName = lib.mkOption {
        type = lib.types.str;
        default = "ICECREAM";
        description = ''
          Network name to connect to. A scheduler with the same name needs to be running.
        '';
      };

      noRemote = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Prevent jobs from other nodes being scheduled on this daemon.
        '';
      };

      schedulerHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Explicit scheduler hostname, useful in firewalled environments.

          Uses scheduler autodiscovery via broadcast if set to null.
        '';
      };

      maxProcesses = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.u16;
        default = null;
        description = ''
          Maximum number of compile jobs started in parallel for this daemon.

          Uses the number of CPUs if set to null.
        '';
      };

      nice = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = ''
          The level of niceness to use.
        '';
      };

      hostname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Hostname of the daemon in the icecream infrastructure.

          Uses the hostname retrieved via uname if set to null.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "icecc";
        description = ''
          User to run the icecream daemon as. Set to root to enable receive of
          remote compile environments.
        '';
      };

      package = lib.mkPackageOption pkgs "icecream" { };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional command line parameters.";
        example = [ "-v" ];
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 10245 ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openBroadcast [ 8765 ];

    systemd.services.icecc-daemon = {
      description = "Icecream compile daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            "${lib.getBin cfg.package}/bin/iceccd"
            "-b"
            "$STATE_DIRECTORY"
            "-u"
            "icecc"
            (toString cfg.nice)
          ]
          ++ lib.optionals (cfg.schedulerHost != null) [
            "-s"
            cfg.schedulerHost
          ]
          ++ lib.optionals (cfg.netName != null) [
            "-n"
            cfg.netName
          ]
          ++ lib.optionals (cfg.cacheLimit != null) [
            "--cache-limit"
            (toString cfg.cacheLimit)
          ]
          ++ lib.optionals (cfg.maxProcesses != null) [
            "-m"
            (toString cfg.maxProcesses)
          ]
          ++ lib.optionals (cfg.hostname != null) [
            "-N"
            (cfg.hostname)
          ]
          ++ lib.optional cfg.noRemote "--no-remote"
          ++ cfg.extraArgs
        );
        DynamicUser = true;
        User = "icecc";
        Group = "icecc";
        StateDirectory = "icecc";
        RuntimeDirectory = "icecc";
        AmbientCapabilities = "CAP_SYS_CHROOT";
        CapabilityBoundingSet = "CAP_SYS_CHROOT";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ emantor ];
}
