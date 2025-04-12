{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tailscale.derper;
in
{
  meta.maintainers = with lib.maintainers; [ SuperSandro2000 ];

  options = {
    services.tailscale.derper = {
      enable = lib.mkEnableOption "Tailscale Derper. See upstream doc <https://tailscale.com/kb/1118/custom-derp-servers> how to configure it on clients";

      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name under which the derper server is reachable.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to open the firewall for the specified port.
          Derper requires the used ports to be opened, otherwise it doesn't work as expected.
        '';
      };

      package = lib.mkPackageOption pkgs [
        "tailscale"
        "derper"
      ] { };

      stunPort = lib.mkOption {
        type = lib.types.port;
        default = 3478;
        description = ''
          STUN port to listen on.
          See online docs <https://tailscale.com/kb/1118/custom-derp-servers#prerequisites> on how to configure a different external port.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8010;
        description = "The port the derper process will listen on. This is not the port tailscale will connect to.";
      };

      verifyClients = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to verify clients against a locally running tailscale daemon if they are allowed to connect to this node or not.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      # port 80 and 443 are opened by nginx already
      allowedUDPPorts = [ cfg.stunPort ];
    };

    services = {
      nginx = {
        enable = true;
        upstreams.tailscale-derper = {
          servers."127.0.0.1:${toString cfg.port}" = { };
          extraConfig = ''
            keepalive 64;
          '';
        };
        virtualHosts."${cfg.domain}" = {
          addSSL = true; # this cannot be forceSSL as derper sends some information over port 80, too.
          locations."/" = {
            proxyPass = "http://tailscale-derper";
            proxyWebsockets = true;
            extraConfig = ''
              keepalive_timeout 0;
              proxy_buffering off;
            '';
          };
        };
      };

      tailscale.enable = lib.mkIf cfg.verifyClients true;
    };

    systemd.services.tailscale-derper = {
      serviceConfig = {
        ExecStart =
          "${lib.getExe' cfg.package "derper"} -a :${toString cfg.port} -c /var/lib/derper/derper.key -hostname=${cfg.domain} -stun-port ${toString cfg.stunPort}"
          + lib.optionalString cfg.verifyClients " -verify-clients";
        DynamicUser = true;
        Restart = "always";
        RestartSec = "5sec"; # don't crash loop immediately
        StateDirectory = "derper";
        Type = "simple";

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = null;
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
