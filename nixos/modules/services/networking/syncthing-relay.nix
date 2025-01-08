{ config, lib, pkgs, ... }:

let
  cfg = config.services.syncthing.relay;

  dataDirectory = "/var/lib/syncthing-relay";

  relayOptions =
    [
      "--keys=${dataDirectory}"
      "--listen=${cfg.listenAddress}:${toString cfg.port}"
      "--status-srv=${cfg.statusListenAddress}:${toString cfg.statusPort}"
      "--provided-by=${lib.escapeShellArg cfg.providedBy}"
    ]
    ++ lib.optional (cfg.pools != null) "--pools=${lib.escapeShellArg (lib.concatStringsSep "," cfg.pools)}"
    ++ lib.optional (cfg.globalRateBps != null) "--global-rate=${toString cfg.globalRateBps}"
    ++ lib.optional (cfg.perSessionRateBps != null) "--per-session-rate=${toString cfg.perSessionRateBps}"
    ++ cfg.extraOptions;
in {
  ###### interface

  options.services.syncthing.relay = {
    enable = lib.mkEnableOption "Syncthing relay service";

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for relay traffic.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 22067;
      description = ''
        Port to listen on for relay traffic. This port should be added to
        `networking.firewall.allowedTCPPorts`.
      '';
    };

    statusListenAddress = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for serving the relay status API.
      '';
    };

    statusPort = lib.mkOption {
      type = lib.types.port;
      default = 22070;
      description = ''
        Port to listen on for serving the relay status API. This port should be
        added to `networking.firewall.allowedTCPPorts`.
      '';
    };

    pools = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = ''
        Relay pools to join. If null, uses the default global pool.
      '';
    };

    providedBy = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Human-readable description of the provider of the relay (you).
      '';
    };

    globalRateBps = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = ''
        Global bandwidth rate limit in bytes per second.
      '';
    };

    perSessionRateBps = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      description = ''
        Per session bandwidth rate limit in bytes per second.
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Extra command line arguments to pass to strelaysrv.
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    systemd.services.syncthing-relay = {
      description = "Syncthing relay service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDirectory;

        Restart = "on-failure";
        ExecStart = "${pkgs.syncthing-relay}/bin/strelaysrv ${lib.concatStringsSep " " relayOptions}";
      };
    };
  };
}
