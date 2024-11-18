{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.icmptx;
in
{
  options = {
    services.icmptx =
      let
        commonOptions = {
          tun = lib.mkOption {
            type = lib.types.str;
            default = "tun0";
            description = ''
              Name of the tunnel interface.
              ICMPTX will just use the first free tun device and since there is no way to tell ICMPTX to use any specific interface name, we have to assume that there are no other tun interfaces and hardcode tun0.
              If ICMPTX ever gains the ability to specify the interface name, this option will become writable.
            '';
            readOnly = true;
          };
        };
      in
      {
        package = lib.mkPackageOption pkgs "icmptx" { };

        server = {
          enable = lib.mkEnableOption ''
            ICMPTX server.
            Make sure that no other network interfaces with the name tun0 exist on the machine. See the description of the option `services.icmptx.server.tun` for an explanation.
          '';

          serverIPv4 = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "1.2.3.4";
            description = "Public IPv4 address of the server";
          };
        } // commonOptions;

        client = {
          enable = lib.mkEnableOption ''
            ICMPTX client.
            Make sure that no other network interfaces with the name tun0 exist on the machine. See the description of the option `services.icmptx.client.tun` for an explanation.
          '';

          serverIPv4 = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "1.2.3.4";
            description = "Public IPv4 address of the server";
          };
        } // commonOptions;
      };
  };

  config =
    let
      commonServiceOptions = {
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
        ];
        DeviceAllow = [ "/dev/net/tun" ];
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = false;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = false;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [ ];
        RemoveIPC = true;
        Restart = "on-failure";
        RestrictAddressFamilies = [ "AF_INET" ]; # Tunnel does not work over IPv6, so no AF_INET6
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        Type = "simple";
        UMask = "0777";
      };
    in
    lib.mkMerge [
      (lib.mkIf (cfg.server.enable || cfg.client.enable) {
        assertions = [
          {
            assertion = config.networking.useNetworkd;
            message = ''
              The ICMPTX NixOS module requires using systemd-networkd rather than the scripted network backend because the scripted network backend does not support assigning an IP address once the interface was created by ICMPTX instead of trying to assign it immediately. Please enable systemd-networkd by setting `networking.useNetworkd` to `true`.
            '';
          }
          {
            assertion = cfg.server.enable != cfg.client.enable;
            message = ''
              Only one of `services.icmptx.server.enable` and `services.icmptx.client.enable` may be enabled at once on any given NixOS system. The reason for this is that ICMPTX will create its tun interface with the first available name without a way to change it and without a way to find out which name the newly created interface has. We therefore hardcode tun0, which would break if more than one instance of this program ran on the given system.
            '';
          }
        ];

        boot.kernelModules = [ "tun" ];

        boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_all" = 1;

        # Prevent sending ping packets through the ping tunnel since that would result in an infinite loop
        networking.firewall.extraCommands = lib.optionalString (!config.networking.nftables.enable) ''
          iptables -A OUTPUT -o tun0 -p icmp --icmp-type echo-request -j DROP
        '';
        networking.nftables.tables.icmptx = lib.optionalAttrs config.networking.nftables.enable {
          family = "ip";
          content = ''
            chain output {
              type filter hook output priority 0; policy accept;
              oifname tun0 icmp type echo-request drop
            }
          '';
        };
      })

      (lib.mkIf (cfg.server.enable) {
        assertions = [
          {
            assertion = builtins.hasAttr "40-${cfg.server.tun}" config.systemd.network.networks;
            message = ''
              You need to manually configure the tunnel interface of ICMPTX, for example by setting `networking.interfaces.''${config.services.icmptx.server.tun}".ipv4.addresses = [{ address = "10.0.3.1"; prefixLength = 24; }]` or by using the appropriate networkd-specific options.
            '';
          }
          {
            assertion = cfg.server.serverIPv4 != "";
            message = ''
              You need to configure the public IPv4 address of the ICMPTX server by setting `services.icmptx.server.serverIPv4`.
            '';
          }
        ];

        systemd.services.icmptx-server = {
          description = "IP-over-ICMP tunnel server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe cfg.package} -s ${utils.escapeSystemdExecArgs [ cfg.server.serverIPv4 ]}";
          } // commonServiceOptions;
        };
      })

      (lib.mkIf (cfg.client.enable) {
        assertions = [
          {
            assertion = builtins.hasAttr "40-${cfg.client.tun}" config.systemd.network.networks;
            message = ''
              You need to manually configure the tunnel interface of ICMPTX, for example by setting `networking.interfaces.''${config.services.icmptx.client.tun}".ipv4.addresses = [{ address = "10.0.3.2"; prefixLength = 24; }]` or by using the appropriate networkd-specific options.
            '';
          }
          {
            assertion = cfg.client.serverIPv4 != "";
            message = ''
              You need to configure the public IPv4 address of the ICMPTX server by setting `services.icmptx.client.serverIPv4`.
            '';
          }
        ];

        systemd.services.icmptx-client = {
          description = "IP-over-ICMP tunnel client";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe cfg.package} -c ${utils.escapeSystemdExecArgs [ cfg.client.serverIPv4 ]}";
            IPAddressDeny = "any";
            IPAddressAllow = cfg.client.serverIPv4;
          } // commonServiceOptions;
        };
      })
    ];
}
