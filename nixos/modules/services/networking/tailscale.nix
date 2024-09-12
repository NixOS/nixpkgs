{ config, lib, pkgs, ... }:
let
  cfg = config.services.tailscale;
  isNetworkd = config.networking.useNetworkd;
in {
  meta.maintainers = with lib.maintainers; [ mbaillie mfrw ];

  options.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale client daemon";

    port = lib.mkOption {
      type = lib.types.port;
      default = 41641;
      description = "The port to listen on for tunnel traffic (0=autoselect).";
    };

    interfaceName = lib.mkOption {
      type = lib.types.str;
      default = "tailscale0";
      description = ''The interface name for tunnel traffic. Use "userspace-networking" (beta) to not use TUN.'';
    };

    permitCertUid = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      description = "Username or user ID of the user allowed to to fetch Tailscale TLS certificates for the node.";
    };

    package = lib.mkPackageOption pkgs "tailscale" {};

    openFirewall = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    useRoutingFeatures = lib.mkOption {
      type = lib.types.enum [ "none" "client" "server" "both" ];
      default = "none";
      example = "server";
      description = ''
        Enables settings required for Tailscale's routing features like subnet routers and exit nodes.

        To use these these features, you will still need to call `sudo tailscale up` with the relevant flags like `--advertise-exit-node` and `--exit-node`.

        When set to `client` or `both`, reverse path filtering will be set to loose instead of strict.
        When set to `server` or `both`, IP forwarding will be enabled.
      '';
    };

    authKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/tailscale_key";
      description = ''
        A file containing the auth key.
      '';
    };

    extraUpFlags = lib.mkOption {
      description = ''
        Extra flags to pass to {command}`tailscale up`. Only applied if `authKeyFile` is specified.";
      '';
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["--ssh"];
    };

    extraSetFlags = lib.mkOption {
      description = "Extra flags to pass to {command}`tailscale set`.";
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["--advertise-exit-node"];
    };

    extraDaemonFlags = lib.mkOption {
      description = "Extra flags to pass to {command}`tailscaled`.";
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["--no-logs-no-support"];
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ]; # for the CLI
    systemd.packages = [ cfg.package ];
    systemd.services.tailscaled = {
      wantedBy = [ "multi-user.target" ];
      path = [
        pkgs.procps     # for collecting running services (opt-in feature)
        pkgs.getent     # for `getent` to look up user shells
        pkgs.kmod       # required to pass tailscale's v6nat check
      ] ++ lib.optional config.networking.resolvconf.enable config.networking.resolvconf.package;
      serviceConfig.Environment = [
        "PORT=${toString cfg.port}"
        ''"FLAGS=--tun ${lib.escapeShellArg cfg.interfaceName} ${lib.concatStringsSep " " cfg.extraDaemonFlags}"''
      ] ++ (lib.optionals (cfg.permitCertUid != null) [
        "TS_PERMIT_CERT_UID=${cfg.permitCertUid}"
      ]);
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

    systemd.services.tailscaled-autoconnect = lib.mkIf (cfg.authKeyFile != null) {
      after = ["tailscaled.service"];
      wants = ["tailscaled.service"];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        status=$(${config.systemd.package}/bin/systemctl show -P StatusText tailscaled.service)
        if [[ $status != Connected* ]]; then
          ${cfg.package}/bin/tailscale up --auth-key 'file:${cfg.authKeyFile}' ${lib.escapeShellArgs cfg.extraUpFlags}
        fi
      '';
    };

    systemd.services.tailscaled-set = lib.mkIf (cfg.extraSetFlags != []) {
      after = ["tailscaled.service"];
      wants = ["tailscaled.service"];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        ${cfg.package}/bin/tailscale set ${lib.escapeShellArgs cfg.extraSetFlags}
      '';
    };

    boot.kernel.sysctl = lib.mkIf (cfg.useRoutingFeatures == "server" || cfg.useRoutingFeatures == "both") {
      "net.ipv4.conf.all.forwarding" = lib.mkOverride 97 true;
      "net.ipv6.conf.all.forwarding" = lib.mkOverride 97 true;
    };

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    networking.firewall.checkReversePath = lib.mkIf (cfg.useRoutingFeatures == "client" || cfg.useRoutingFeatures == "both") "loose";

    networking.dhcpcd.denyInterfaces = [ cfg.interfaceName ];

    systemd.network.networks."50-tailscale" = lib.mkIf isNetworkd {
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
