{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncthing.relay;

  dataDirectory = "/var/lib/syncthing-relay";

  relayOptions =
    [
      "--keys=${dataDirectory}"
      "--listen=${cfg.listenAddress}:${toString cfg.port}"
      "--status-srv=${cfg.statusListenAddress}:${toString cfg.statusPort}"
      "--provided-by=${escapeShellArg cfg.providedBy}"
    ]
    ++ optional (cfg.pools != null) "--pools=${escapeShellArg (concatStringsSep "," cfg.pools)}"
    ++ optional (cfg.globalRateBps != null) "--global-rate=${toString cfg.globalRateBps}"
    ++ optional (cfg.perSessionRateBps != null) "--per-session-rate=${toString cfg.perSessionRateBps}"
    ++ cfg.extraOptions;
in {
  ###### interface

  options.services.syncthing.relay = {
    enable = mkEnableOption "Syncthing relay service";

    listenAddress = mkOption {
      type = types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for relay traffic.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 22067;
      description = ''
        Port to listen on for relay traffic. This port should be added to
        <literal>networking.firewall.allowedTCPPorts</literal>.
      '';
    };

    statusListenAddress = mkOption {
      type = types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for serving the relay status API.
      '';
    };

    statusPort = mkOption {
      type = types.port;
      default = 22070;
      description = ''
        Port to listen on for serving the relay status API. This port should be
        added to <literal>networking.firewall.allowedTCPPorts</literal>.
      '';
    };

    pools = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        Relay pools to join. If null, uses the default global pool.
      '';
    };

    providedBy = mkOption {
      type = types.str;
      default = "";
      description = ''
        Human-readable description of the provider of the relay (you).
      '';
    };

    globalRateBps = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = ''
        Global bandwidth rate limit in bytes per second.
      '';
    };

    perSessionRateBps = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = ''
        Per session bandwidth rate limit in bytes per second.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra command line arguments to pass to strelaysrv.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.syncthing-relay = {
      description = "Syncthing relay service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDirectory;

        Restart = "on-failure";
        ExecStart = "${pkgs.syncthing-relay}/bin/strelaysrv ${concatStringsSep " " relayOptions}";
      };
    };
  };
}
