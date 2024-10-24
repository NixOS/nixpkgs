{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tailscale;
  isNetworkd = config.networking.useNetworkd;
in {
  meta.maintainers = with maintainers; [ mbaillie mfrw ];

  options.services.tailscale = {
    enable = mkEnableOption "Tailscale client daemon";

    port = mkOption {
      type = types.port;
      default = 41641;
      description = "The port to listen on for tunnel traffic (0=autoselect).";
    };

    interfaceName = mkOption {
      type = types.str;
      default = "tailscale0";
      description = ''The interface name for tunnel traffic. Use "userspace-networking" (beta) to not use TUN.'';
    };

    permitCertUid = mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = "Username or user ID of the user allowed to to fetch Tailscale TLS certificates for the node.";
    };

    package = lib.mkPackageOption pkgs "tailscale" {};

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    useRoutingFeatures = mkOption {
      type = types.enum [ "none" "client" "server" "both" ];
      default = "none";
      example = "server";
      description = ''
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
      description = ''
        A file containing the auth key.
        Tailscale will be automatically started if provided.
      '';
    };

    authKeyParameters = mkOption {
      type = types.submodule {
        options = {
          ephemeral = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = "Whether to register as an ephemeral node.";
          };
          preauthorized = mkOption {
            type = types.nullOr types.bool;
            default = null;
            description = "Whether to skip manual device approval.";
          };
          baseURL = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Base URL for the Tailscale API.";
          };
        };
      };
      default = { };
      description = ''
        Extra parameters to pass after the auth key.
        See https://tailscale.com/kb/1215/oauth-clients#registering-new-nodes-using-oauth-credentials
      '';
    };

    extraUpFlags = mkOption {
      description = ''
        Extra flags to pass to {command}`tailscale up`. Only applied if `authKeyFile` is specified.";
      '';
      type = types.listOf types.str;
      default = [];
      example = ["--ssh"];
    };

    extraSetFlags = mkOption {
      description = "Extra flags to pass to {command}`tailscale set`.";
      type = types.listOf types.str;
      default = [];
      example = ["--advertise-exit-node"];
    };

    extraDaemonFlags = mkOption {
      description = "Extra flags to pass to {command}`tailscaled`.";
      type = types.listOf types.str;
      default = [];
      example = ["--no-logs-no-support"];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ]; # for the CLI
    systemd.packages = [ cfg.package ];
    systemd.services.tailscaled = {
      after = lib.mkIf (config.networking.networkmanager.enable) [ "NetworkManager-wait-online.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        (builtins.dirOf config.security.wrapperDir) # for `su` to use taildrive with correct access rights
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

    systemd.services.tailscaled-autoconnect = mkIf (cfg.authKeyFile != null) {
      after = ["tailscaled.service"];
      wants = ["tailscaled.service"];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      # https://github.com/tailscale/tailscale/blob/v1.72.1/ipn/backend.go#L24-L32
      script = let
        statusCommand = "${lib.getExe cfg.package} status --json --peers=false | ${lib.getExe pkgs.jq} -r '.BackendState'";
        paramToString = v:
          if (builtins.isBool v) then (lib.boolToString v)
          else (toString v);
        params = lib.pipe cfg.authKeyParameters [
          (lib.filterAttrs (_: v: v != null))
          (lib.mapAttrsToList (k: v: "${k}=${paramToString v}"))
          (builtins.concatStringsSep "&")
          (params: if params != "" then "?${params}" else "")
        ];
      in ''
        while [[ "$(${statusCommand})" == "NoState" ]]; do
          sleep 0.5
        done
        status=$(${statusCommand})
        if [[ "$status" == "NeedsLogin" || "$status" == "NeedsMachineAuth" ]]; then
          ${lib.getExe cfg.package} up --auth-key "$(cat ${cfg.authKeyFile})${params}" ${escapeShellArgs cfg.extraUpFlags}
        fi
      '';
    };

    systemd.services.tailscaled-set = mkIf (cfg.extraSetFlags != []) {
      after = ["tailscaled.service"];
      wants = ["tailscaled.service"];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        ${lib.getExe cfg.package} set ${escapeShellArgs cfg.extraSetFlags}
      '';
    };

    boot.kernel.sysctl = mkIf (cfg.useRoutingFeatures == "server" || cfg.useRoutingFeatures == "both") {
      "net.ipv4.conf.all.forwarding" = mkOverride 97 true;
      "net.ipv6.conf.all.forwarding" = mkOverride 97 true;
    };

    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ cfg.port ];

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
