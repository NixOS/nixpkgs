{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tayga;

  # Converts an address set to a string
  strAddr = addr: "${addr.address}/${toString addr.prefixLength}";

  configFile = pkgs.writeText "tayga.conf" ''
    tun-device ${cfg.tunDevice}

    ipv4-addr ${cfg.ipv4.address}
    ${optionalString (cfg.ipv6.address != null) "ipv6-addr ${cfg.ipv6.address}"}

    prefix ${strAddr cfg.ipv6.pool}
    dynamic-pool ${strAddr cfg.ipv4.pool}
    data-dir ${cfg.dataDir}
  '';

  addrOpts = v:
    assert v == 4 || v == 6;
    {
      options = {
        address = mkOption {
          type = types.str;
          description = lib.mdDoc "IPv${toString v} address.";
        };

        prefixLength = mkOption {
          type = types.addCheck types.int (n: n >= 0 && n <= (if v == 4 then 32 else 128));
          description = lib.mdDoc ''
            Subnet mask of the interface, specified as the number of
            bits in the prefix ("${if v == 4 then "24" else "64"}").
          '';
        };
      };
    };

  versionOpts = v: {
    options = {
      router = {
        address = mkOption {
          type = types.str;
          description = lib.mdDoc "The IPv${toString v} address of the router.";
        };
      };

      address = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "The source IPv${toString v} address of the TAYGA server.";
      };

      pool = mkOption {
        type = with types; nullOr (submodule (addrOpts v));
        description = lib.mdDoc "The pool of IPv${toString v} addresses which are used for translation.";
      };
    };
  };
in
{
  options = {
    services.tayga = {
      enable = mkEnableOption (lib.mdDoc "Tayga");

      package = mkOption {
        type = types.package;
        default = pkgs.tayga;
        defaultText = lib.literalMD "pkgs.tayga";
        description = lib.mdDoc "This option specifies the TAYGA package to use.";
      };

      ipv4 = mkOption {
        type = types.submodule (versionOpts 4);
        description = lib.mdDoc "IPv4-specific configuration.";
        example = literalExpression ''
          {
            address = "192.0.2.0";
            router = {
              address = "192.0.2.1";
            };
            pool = {
              address = "192.0.2.1";
              prefixLength = 24;
            };
          }
        '';
      };

      ipv6 = mkOption {
        type = types.submodule (versionOpts 6);
        description = lib.mdDoc "IPv6-specific configuration.";
        example = literalExpression ''
          {
            address = "2001:db8::1";
            router = {
              address = "64:ff9b::1";
            };
            pool = {
              address = "64:ff9b::";
              prefixLength = 96;
            };
          }
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/tayga";
        description = lib.mdDoc "Directory for persistent data";
      };

      tunDevice = mkOption {
        type = types.str;
        default = "nat64";
        description = lib.mdDoc "Name of the nat64 tun device";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.interfaces."${cfg.tunDevice}" = {
      virtual = true;
      virtualType = "tun";
      virtualOwner = mkIf config.networking.useNetworkd "";
      ipv4 = {
        addresses = [
          { address = cfg.ipv4.router.address; prefixLength = 32; }
        ];
        routes = [
          cfg.ipv4.pool
        ];
      };
      ipv6 = {
        addresses = [
          { address = cfg.ipv6.router.address; prefixLength = 128; }
        ];
        routes = [
          cfg.ipv6.pool
        ];
      };
    };

    systemd.services.tayga = {
      description = "Stateless NAT64 implementation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tayga -d --nodetach --config ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        Restart = "always";

        # Hardening Score:
        #  - nixos-scripts: 2.1
        #  - systemd-networkd: 1.6
        ProtectHome = true;
        SystemCallFilter = [
          "@network-io"
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ProtectKernelLogs = true;
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
        ];
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        StateDirectory = "tayga";
        DynamicUser = mkIf config.networking.useNetworkd true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        NoNewPrivileges = true;
        ProtectControlGroups = true;
        SystemCallArchitectures = "native";
        PrivateTmp = true;
        LockPersonality = true;
        ProtectSystem = true;
        PrivateUsers = true;
        ProtectProc = "invisible";
      };
    };
  };
}
