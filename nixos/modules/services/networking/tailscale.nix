{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tailscale;
  isNetworkd = config.networking.useNetworkd;
in
{
  meta.maintainers = with maintainers; [ danderson mbaillie twitchyliquid64 ];

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

    package = mkOption {
      type = types.package;
      default = pkgs.tailscale;
      defaultText = literalExpression "pkgs.tailscale";
      description = lib.mdDoc "The package to use for tailscale";
    };

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

    client = {
      enable = mkEnableOption (lib.mdDoc "Enable Tailscale autoconnect");

      authkeyFile = mkOption {
        type = types.str;
        description = lib.mdDoc "The authkey to use for authentication with Tailscale";
        example = "/var/lib/secrets/tailscale/authkey";
      };

      loginServer = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc "The login server to use for authentication with Tailscale";
        example = "https://login.tailscale.com";
      };

      advertiseExitNode = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to advertise this node as an exit node";
      };

      exitNode = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc "The exit node to use for this node";
        example = "my-exit-node";
      };

      exitNodeAllowLanAccess = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to allow LAN access to this node";
      };

      otherFlags = mkOption {
        type = types.listOf types.str;
        default = [""];
        description = lib.mdDoc "Other flags to pass to `tailscale up`";
        example = ["--shields-up" "--ssh"];
      };
    };
  };

  config =
    let
      daemon = lib.mkIf cfg.enable {
        environment.systemPackages = [ cfg.package ]; # for the CLI
        systemd.packages = [ cfg.package ];
        systemd.services.tailscaled = {
          wantedBy = [ "multi-user.target" ];
          path = [
            config.networking.resolvconf.package # for configuring DNS in some configs
            pkgs.procps # for collecting running services (opt-in feature)
            pkgs.glibc # for `getent` to look up user shells
            pkgs.kmod # required to pass tailscale's v6nat check
          ];
          serviceConfig.Environment = [
            "PORT=${toString cfg.port}"
            ''"FLAGS=--tun ${lib.escapeShellArg cfg.interfaceName}"''
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

      client = lib.mkIf cfg.client.enable {
        assertions = [
          {
            assertion = cfg.client.enable -> cfg.enable;
            message = "client.enable must be false if enable is false";
          }
          {
            assertion = cfg.client.authkeyFile != "";
            message = "authkeyFile must be set";
          }
          {
            assertion = cfg.client.exitNodeAllowLanAccess -> cfg.client.exitNode != "";
            message = "exitNodeAllowLanAccess must be false if exitNode is not set";
          }
          {
            assertion = cfg.client.advertiseExitNode -> cfg.client.exitNode == "";
            message = "advertiseExitNode must be false if exitNode is set";
          }
          {
            assertion = cfg.client.advertiseExitNode -> cfg.useRoutingFeatures == "server" || cfg.useRoutingFeatures == "both";
            message = "advertiseExitNode must be false if useRoutingFeatures is not server or both";
          }
        ];

        systemd.services.tailscale-autoconnect = {
          description = "Automatic connection to Tailscale";

          # make sure tailscale is running before trying to connect to tailscale
          after = [ "network-pre.target" "tailscale.service" ];
          wants = [ "network-pre.target" "tailscale.service" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig.Type = "oneshot";

          script = with pkgs; ''
            # wait for tailscaled to settle
            sleep 2

            # check if we are already authenticated to tailscale
            status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
            echo "tailscale status: $status"
            if [ "$status" != "NeedsLogin" ]; then
                exit 0
            fi

            # otherwise authenticate with tailscale
            # timeout after 10 seconds to avoid hanging the boot process
            ${coreutils}/bin/timeout 10 ${tailscale}/bin/tailscale up \
              ${lib.optionalString (cfg.client.loginServer != "") "--login-server=${cfg.client.loginServer}"} \
              --authkey=$(cat "${cfg.client.authkeyFile}")

            # we have to proceed in two steps because some options are only available
            # after authentication
            ${coreutils}/bin/timeout 10 ${tailscale}/bin/tailscale up \
              ${lib.optionalString (cfg.client.loginServer != "") "--login-server=${cfg.client.loginServer}"} \
              ${lib.optionalString (cfg.client.advertiseExitNode) "--advertise-exit-node"} \
              ${lib.optionalString (cfg.client.exitNode != "") "--exit-node=${cfg.client.exitNode}"} \
              ${lib.optionalString (cfg.client.exitNodeAllowLanAccess) "--exit-node-allow-lan-access"} \
              ${escapeShellArgs cfg.client.otherFlags}
          '';
        };
      };
    in
      lib.mkMerge [ daemon client ];
    }
