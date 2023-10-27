{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tailscale;
  isNetworkd = config.networking.useNetworkd;
in {
  meta.maintainers = with maintainers; [ danderson mbaillie twitchyliquid64 mfrw ];

  options.services.tailscale = {
    enable = mkEnableOption (lib.mdDoc "Tailscale client daemon");

    port = mkOption {
      type = types.port;
      default = 41641;
      description = lib.mdDoc "The port to listen on for tunnel traffic (0=autoselect).";
    };

    interfaceName = mkOption {
      type = types.str;
      default = "tailscale0";
      description = lib.mdDoc ''The interface name for tunnel traffic. Use "userspace-networking" (beta) to not use TUN.'';
    };

    permitCertUid = mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = lib.mdDoc "Username or user ID of the user allowed to to fetch Tailscale TLS certificates for the node.";
    };

    enableLogUpload = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables upload of logs to the central log collection server at log.tailscale.io.
        Tailscale will use this logs in case of technical customer support to gather insights on whats happening on a given tailnet.
        Disabling logging means limited technical support will be available.

        See https://tailscale.com/kb/1011/log-mesh-traffic/#opting-out-of-client-logging for details.
      '';
    };

    package = lib.mkPackageOptionMD pkgs "tailscale" {};

    useRoutingFeatures = mkOption {
      type = types.enum [ "none" "client" "server" "both" ];
      default = "none";
      example = "server";
      description = lib.mdDoc ''
        Enables settings required for Tailscale's routing features like subnet routers and exit nodes.

        To use these these features, you will still need to call `sudo tailscale up` with the relevant flags like `--advertise-exit-node` and `--exit-node`.

        When set to `client` or `both`, reverse path filtering will be set to loose instead of strict.
        When set to `server` or `both`, IP forwarding will be enabled.
      '';
    };

    authKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/tailscale_key";
      description = lib.mdDoc ''
        A file containing the auth key.
      '';
    };

    extraUpFlags = mkOption {
      description = lib.mdDoc "Extra flags to pass to {command}`tailscale up`.";
      type = types.listOf types.str;
      default = [];
      example = ["--ssh"];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ]; # for the CLI
    systemd.packages = [ cfg.package ];
    systemd.services.tailscaled = {
      wantedBy = [ "multi-user.target" ];
      path = [
        config.networking.resolvconf.package # for configuring DNS in some configs
        pkgs.procps     # for collecting running services (opt-in feature)
        pkgs.getent     # for `getent` to look up user shells
        pkgs.kmod       # required to pass tailscale's v6nat check
      ];
      serviceConfig.Environment = [
        "PORT=${toString cfg.port}"
        ''"FLAGS=--tun ${lib.escapeShellArg cfg.interfaceName}"''
      ] ++ (lib.optionals (cfg.permitCertUid != null) [
        "TS_PERMIT_CERT_UID=${cfg.permitCertUid}"
      ]) ++ (lib.optionals (!cfg.enableLogUpload) [ "TS_NO_LOGS_NO_SUPPORT=true" ]);

      # Restart tailscaled with a single `systemctl restart` at the
      # end of activation, rather than a `stop` followed by a later
      # `start`. Activation over Tailscale can hang for tens of
      # seconds in the stop+start setup, if the activation script has
      # a significant delay between the stop and start phases
      # (e.g. script blocked on another unit with a slow shutdown).
      #
      # Tailscale is aware of the correctness tradeoff involved, and
      # already makes its upstream systemd unit robust against unit
      # version mismatches on restart for compatibility with other
      # linux distros.
      stopIfChanged = false;
    };

    systemd.services.tailscaled-autoconnect = mkIf (cfg.authKeyFile != null) {
      after = ["tailscale.service"];
      wants = ["tailscale.service"];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        status=$(${config.systemd.package}/bin/systemctl show -P StatusText tailscaled.service)
        if [[ $status != Connected* ]]; then
          ${cfg.package}/bin/tailscale up --auth-key 'file:${cfg.authKeyFile}' ${escapeShellArgs cfg.extraUpFlags}
        fi
      '';
    };

    boot.kernel.sysctl = mkIf (cfg.useRoutingFeatures == "server" || cfg.useRoutingFeatures == "both") {
      "net.ipv4.conf.all.forwarding" = mkOverride 97 true;
      "net.ipv6.conf.all.forwarding" = mkOverride 97 true;
    };

    networking.firewall.checkReversePath = mkIf (cfg.useRoutingFeatures == "client" || cfg.useRoutingFeatures == "both") "loose";

    networking.dhcpcd.denyInterfaces = [ cfg.interfaceName ];

    systemd.network.networks."50-tailscale" = mkIf isNetworkd {
      matchConfig = {
        Name = cfg.interfaceName;
      };
      linkConfig = {
        Unmanaged = true;
        ActivationPolicy = "manual";
      };
    };
  };
}
