{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.tayga;

  # Converts an address set to a string
  strAddr = addr: "${addr.address}/${toString addr.prefixLength}";

  renderValue =
    v:
    if isBool v then
      boolToYesNo v
    else if isList v then
      concatStringsSep " " v
    else
      toString v;

  # map is the only directive that may appear more than once.
  renderDirective =
    name: value:
    if name == "map" then
      mapAttrsToList (ipv4: ipv6: "map ${ipv4} ${ipv6}") value
    else
      optional (value != null && value != [ ]) "${name} ${renderValue value}";

  configFile = pkgs.writeText "tayga.conf" (
    concatLines (concatLists (mapAttrsToList renderDirective cfg.settings))
  );

  addrOpts =
    v:
    assert v == 4 || v == 6;
    {
      options = {
        address = mkOption {
          type = types.str;
          description = "IPv${toString v} address.";
        };

        prefixLength = mkOption {
          type = types.ints.between 0 (if v == 4 then 32 else 128);
          description = ''
            Subnet mask of the interface, specified as the number of
            bits in the prefix ("${if v == 4 then "24" else "64"}").
          '';
        };
      };
    };

  versionOpts = v: {
    router = {
      address = mkOption {
        type = types.str;
        description = "The IPv${toString v} address of the router.";
      };
    };

    pool = mkOption {
      type = with types; nullOr (submodule (addrOpts v));
      description = "The pool of IPv${toString v} addresses which are used for translation.";
    };
  };

  renamed =
    from: to:
    mkRenamedOptionModule
      (
        [
          "services"
          "tayga"
        ]
        ++ from
      )
      [
        "services"
        "tayga"
        "settings"
        to
      ];
in
{
  imports = [
    (renamed [ "ipv4" "address" ] "ipv4-addr")
    (renamed [ "ipv6" "address" ] "ipv6-addr")
    (renamed [ "dataDir" ] "data-dir")
    (renamed [ "tunDevice" ] "tun-device")
    (renamed [ "mappings" ] "map")
    (renamed [ "log" ] "log")
    (renamed [ "wkpfStrict" ] "wkpf-strict")
  ];

  options = {
    services.tayga = {
      enable = mkEnableOption "Tayga";

      package = mkPackageOption pkgs "tayga" { };

      ipv4 = versionOpts 4;

      ipv6 = versionOpts 6;

      settings = mkOption {
        description = ''
          Configuration for TAYGA, see {manpage}`tayga.conf(5)` for the
          available directives. Lists are written space separated on a
          single line, `null` values are omitted.
        '';
        default = { };
        type = types.submodule {
          freeformType =
            with types;
            attrsOf (
              nullOr (oneOf [
                bool
                int
                str
                (listOf str)
              ])
            );

          options = {
            tun-device = mkOption {
              type = types.str;
              default = "nat64";
              description = "Name of the nat64 tun device.";
            };

            ipv4-addr = mkOption {
              type = types.str;
              description = "The source IPv4 address of the TAYGA server.";
            };

            ipv6-addr = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "The source IPv6 address of the TAYGA server.";
            };

            prefix = mkOption {
              type = types.nullOr types.str;
              default = if cfg.ipv6.pool != null then strAddr cfg.ipv6.pool else null;
              defaultText = literalExpression ''"''${config.services.tayga.ipv6.pool.address}/''${toString config.services.tayga.ipv6.pool.prefixLength}"'';
              description = "The NAT64 prefix.";
            };

            dynamic-pool = mkOption {
              type = types.nullOr types.str;
              default = if cfg.ipv4.pool != null then strAddr cfg.ipv4.pool else null;
              defaultText = literalExpression ''"''${config.services.tayga.ipv4.pool.address}/''${toString config.services.tayga.ipv4.pool.prefixLength}"'';
              description = "The IPv4 pool from which TAYGA assigns addresses to IPv6 hosts.";
            };

            data-dir = mkOption {
              type = types.path;
              default = "/var/lib/tayga";
              description = "Directory for persistent data.";
            };

            map = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "Static IPv4 -> IPv6 host mappings.";
              example = literalExpression ''
                {
                  "192.168.5.42" = "2001:db8:1:4444::1";
                  "192.168.5.43" = "2001:db8:1:4444::2";
                  "192.168.255.2" = "2001:db8:1:569::143";
                }
              '';
            };

            log = mkOption {
              type = types.listOf (
                types.enum [
                  "drop"
                  "reject"
                  "icmp"
                  "self"
                  "dyn"
                ]
              );
              default = [ ];
              description = "Packet errors to log.";
              example = [
                "drop"
                "reject"
                "icmp"
                "self"
              ];
            };

            wkpf-strict = mkOption {
              type = types.bool;
              default = true;
              description = "Enable restrictions on the use of the well-known prefix (64:ff9b::/96) - prevents translation of non-global IPv4 ranges when using the well-known prefix. Must be enabled for RFC 6052 compatibility.";
            };

            udp-cksum-mode = mkOption {
              type = types.enum [
                "drop"
                "calc"
                "fwd"
              ];
              default = "drop";
              description = ''
                How to handle IPv4 UDP packets with a zero checksum, which
                IPv6 does not allow. `calc` computes a checksum, `fwd`
                forwards the packet unchanged and `drop` discards it.
                Zero checksums are common for ESP-in-UDP (RFC 3948), for
                example with VoWiFi.
              '';
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = allUnique (attrValues cfg.settings.map);
        message = "Neither the IPv4 nor the IPv6 addresses must be entered twice in the mappings.";
      }
    ];

    users.groups.tayga-tun = { };

    networking.interfaces."${cfg.settings.tun-device}" = {
      virtual = true;
      virtualType = "tun";
      virtualOwner = null;
      virtualGroup = config.users.groups.tayga-tun.name;
      ipv4 = {
        addresses = [
          {
            address = cfg.ipv4.router.address;
            prefixLength = 32;
          }
        ];
        routes = [
          cfg.ipv4.pool
        ];
      };
      ipv6 = {
        addresses = [
          {
            address = cfg.ipv6.router.address;
            prefixLength = 128;
          }
        ];
        routes = [
          cfg.ipv6.pool
        ];
      };
    };

    environment.etc."tayga.conf".source = configFile;

    systemd.services.tayga = {
      description = "Stateless NAT64 implementation";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      reloadTriggers = [ configFile ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/tayga -d --nodetach --config /etc/tayga.conf";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        Restart = "always";

        # Hardening Score: 1.5
        ProtectHome = true;
        SystemCallFilter = [
          "@network-io"
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ProtectKernelLogs = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        StateDirectory = "tayga";
        DynamicUser = true;
        SupplementaryGroups = [ config.users.groups.tayga-tun.name ];
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
