{
  utils,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.zapret2;

  profileSubmodule =
    { config, name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = name;
          defaultText = "‹name›";
          description = "A unique string that identifies this profile.";
        };

        priority = lib.mkOption {
          type = lib.types.int;
          default = 1000;
          example = 0;
          description = ''
            The priority for the profile when constructing the command-line
            parameters. Lower priority values will cause the profile to be
            ordered before others, meaning it will be matched before others.
            Higher priority values will cause the profile to be ordered after
            others, meaning it will be matched after others.
          '';
        };

        ips = {
          include = lib.mkOption {
            type = lib.types.nullOr (lib.types.uniq (lib.types.listOf lib.types.nonEmptyStr));
            default = null;
            example = [
              "213.59.192.0/18"
            ];
            description = ''
              An explicit list of IP addresses to include in the DPI bypass.
              Each member is an IPv4 or IPv6 address, or a subnet in CIDR
              notation.

              If set to null (the default), no include list is set, meaning all
              IP addresses are included in the DPI bypass. If set to an empty
              list, the include list will be empty, and no IP address will be
              included in the DPI bypass.
            '';
          };

          exclude = lib.mkOption {
            type = lib.types.nullOr (lib.types.uniq (lib.types.listOf lib.types.nonEmptyStr));
            default = null;
            example = [
              "173.245.48.0/20"
              "103.21.244.0/22"
              "103.22.200.0/22"
              "103.31.4.0/22"
              "141.101.64.0/18"
              "108.162.192.0/18"
              "190.93.240.0/20"
              "188.114.96.0/20"
              "197.234.240.0/22"
              "198.41.128.0/17"
              "162.158.0.0/15"
              "104.16.0.0/13"
              "104.24.0.0/14"
              "172.64.0.0/13"
              "131.0.72.0/22"
            ];
            description = ''
              An explicit list of IP addresses to exclude from the DPI bypass.
              Each member is an IPv4 or IPv6 address, or a subnet in CIDR
              notation.

              If set to null (the default) or an empty list, no exclude list is
              set, meaning no IP addresses are excluded from the DPI bypass.
            '';
          };
        };

        hosts = {
          include = lib.mkOption {
            type = lib.types.nullOr (lib.types.uniq (lib.types.listOf lib.types.nonEmptyStr));
            default = null;
            example = [
              "youtube.com"
              "chess.com"
            ];
            description = ''
              An explicit list of hostnames to include in the DPI bypass. Each
              member is a hostname, optionally prefixed with ^ to be a strict
              match (by default all subdomains are matched).

              If set to null (the default), no include list is set, meaning all
              hostnames are included in the DPI bypass. If set to an empty
              list, the include list will be empty, and no hostname will be
              included in the DPI bypass.
            '';
          };

          exclude = lib.mkOption {
            type = lib.types.nullOr (lib.types.uniq (lib.types.listOf lib.types.nonEmptyStr));
            default = null;
            example = [
              "ru"
              "yandex.net"
              "yastatic.net"
            ];
            description = ''
              An explicit list of hostnames to exclude from the DPI bypass.
              Each member is a hostname, optionally prefixed with ^ to be a
              strict match (by default all subdomains are matched).

              If set to null (the default) or an empty list, no exclude list is
              set, meaning no hostnames are excluded from the DPI bypass.
            '';
          };

          auto = {
            enable = lib.mkEnableOption ''
              automatic tracking of which hosts the DPI bypass is necessary for
            '';

            file = lib.mkOption {
              type = lib.types.path;
              default = "/var/lib/zapret2/${config.name}-hosts.txt";
              defaultText = "/var/lib/zapret2/‹name›-hosts.txt";
              description = ''
                The file where the automatic host list is saved. This path must
                be writable by the user Zapret2 runs as (by default, it uses a
                dynamic user, so it must be in {file}`/var/lib/zapret2`).
              '';
            };
          };
        };

        parameters = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "--filter-tcp=443"
            "--payload=tls_client_hello"
            "--lua-desync=fake:blob=fake_default_tls:tcp_ts=-1000:repeats=1"
            "--lua-desync=fakedsplit:pos=1,midsld:tcp_ts=-1000"
          ];
          description = ''
            The parameters to use for this profile. Note that, when using
            multiple profiles, a {option}`--filter-*` parameter MUST be defined,
            otherwise the first profile will match everything and no other
            profile will even be executed.

            To obtain a list of suitable parameters, consider running the
            `blockcheck2` program (part of the zapret2 package), searching the
            [Zapret forums][1] for community solutions, or consulting the
            [Zapret manual][2].

            [1]: https://ntc.party/c/community-software/zapret-antidpi/
            [2]: https://github.com/bol-van/zapret2/blob/master/docs/manual.md
          '';
        };
      };

      config.parameters = lib.mkMerge [
        (lib.mkIf (config.ips.include != null) (
          lib.mkBefore [
            "--ipset=${pkgs.writeText "zapret2-ips-include.txt" (lib.concatLines config.ips.include)}"
          ]
        ))
        (lib.mkIf (config.ips.exclude != null) (
          lib.mkBefore [
            "--ipset-exclude=${pkgs.writeText "zapret2-ips-exclude.txt" (lib.concatLines config.ips.exclude)}"
          ]
        ))
        (lib.mkIf (config.hosts.include != null) (
          lib.mkBefore [
            "--hostlist=${pkgs.writeText "zapret2-hosts-include.txt" (lib.concatLines config.hosts.include)}"
          ]
        ))
        (lib.mkIf (config.hosts.exclude != null) (
          lib.mkBefore [
            "--hostlist-exclude=${pkgs.writeText "zapret2-hosts-exclude.txt" (lib.concatLines config.hosts.exclude)}"
          ]
        ))
        (lib.mkIf config.hosts.auto.enable (
          lib.mkAfter [
            "--hostlist-auto=${config.hosts.auto.file}"
          ]
        ))
      ];
    };

  arguments =
    let
      fileOptions =
        let
          isAbsolute = x: builtins.isPath x || lib.hasPrefix "/" x;
          toFile = x: if isAbsolute x then x else "${cfg.package}/share/zapret2/lua/${x}.lua";
        in
        map (x: "--lua-init=@${toFile x}") cfg.files;
      profileOptions =
        let
          sorted = builtins.sort (a: b: a.priority < b.priority) (builtins.attrValues cfg.profiles);
          toArgs = profile: [ "--name=${profile.name}" ] ++ profile.parameters;
        in
        builtins.foldl' (acc: p: acc ++ lib.optional (acc != [ ]) "--new" ++ toArgs p) [ ] sorted;
    in
    [
      (lib.getExe cfg.package)
      "--qnum=${toString cfg.firewall.queue}"
      "--fwmark=${toString cfg.firewall.desyncMark}"
    ]
    ++ fileOptions
    ++ profileOptions
    ++ cfg.extraOptions;
in

{
  options.services.zapret2 = {
    enable = lib.mkEnableOption "zapret2, an extensible DPI bypass program";
    package = lib.mkPackageOption pkgs "zapret2" { };

    profiles = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule profileSubmodule);
      default = { };
      example = {
        https.parameters = [
          "--filter-tcp=443"
          "--payload=tls_client_hello"
          "--lua-desync=fake:blob=fake_default_tls:tcp_ts=-1000:repeats=1"
          "--lua-desync=fakedsplit:pos=1,midsld:tcp_ts=-1000"
        ];
      };
      description = ''
        Defines DPI bypass profiles for Zapret2. For each item in the attrset,
        the key will be used as the profile name, and the value will be the
        command-line parameters passed to the profile.

        Note that each profile should have a unique {option}`--filter-*`
        option. By default, a profile matches all traffic, and when a profile
        matches some traffic, no other profile is evaluated. Since profiles are
        matched in order they are passed on the command line, the ordering of
        profiles is important, and if a "fallback"/catch-all profile is
        defined, it should be defined with a high priority to make sure it is
        last in the list of profiles.

        Each profile will be prepended with the {option}`--name` option to set
        the name, and then joined together with {option}`--new` between
        profiles to form the final command-line parameters that will be passed
        to Zapret2. Therefore, neither {option}`--name` nor {option}`--new`
        should be used in the values.
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--debug" ];
      description = ''
        Extra command line parameters to pass to Zapret2.

        Profiles and desync strategies should not be set here, instead the
        {option}`services.zapret2.profiles` option should be used instead,
        which allows profiles to be defined and merged correctly across
        multiple NixOS modules.

        The {option}`--lua-init` parameters should not be included here, the
        files to load should instead be set via the
        {option}`services.zapret2.files` option.

        Likewise, the {option}`--qnum` and {option}`--fwmark` parameters should
        also not be included, instead the queue number and firewall desync mark
        can be set using the {option}`services.zapret2.firewall.queue` and
        {option}`services.zapret2.firewall.desyncMark` options respectively.
      '';
    };

    files = lib.mkOption {
      type = lib.types.listOf (lib.types.either lib.types.nonEmptyStr lib.types.path);
      default = [
        "zapret-lib"
        "zapret-antidpi"
      ];
      example = [
        "zapret-lib"
        "zapret-obfs"
        "/path/to/custom.lua"
      ];
      description = ''
        List of Lua files that will be loaded and executed once on startup.
        Each entry in the list can be either an absolute path (including the
        .lua extension) or the name of a standard library file bundled with
        zapret2 (without the .lua extension). In case of the latter, they
        will be automatically resolved to the files in the configured zapret2
        package.
      '';
    };

    firewall = {
      configureAutomatically = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = ''
          Whether to automatically configure the firewall rules to apply the
          DPI bypass to all outgoing non-local connections (using nftables).

          If disabled, the only options that will be used are
          {option}`firewall.queue` and {option}`firewall.desyncMark`, for the
          {option}`--qnum` and {option}`--fwmark` parameters respectively.
        '';
      };

      maxPackets = lib.mkOption {
        type = lib.types.nullOr (lib.types.ints.between 2 65535);
        default = 16;
        example = 20;
        description = ''
          The number of packets in each connection to route via Zapret2. For
          example, a value of 16 will only subject the first 16 packets in each
          connection to anti-DPI measures. It's recommended to keep this value
          low in order to avoid routing unnecessary traffic through userspace
          if possible. However, if necessary, all traffic can be routed by
            setting this option to null.
        '';
      };

      interfaces = lib.mkOption {
        type = lib.types.nullOr (lib.types.nonEmptyListOf lib.types.nonEmptyStr);
        default = null;
        example = [ "eth0" ];
        description = ''
          A filter for which interfaces to apply the DPI bypass to. Setting
          this option to null (the default) means the DPI bypass applies to
          all interfaces.
        '';
      };

      allowedTCPPorts = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.port);
        default = null;
        example = [
          80
          443
        ];
        description = ''
          A list of destination TCP ports to apply the DPI bypass to. Setting
          this option to null (the default) means the DPI bypass applies to
          all TCP connections. Setting this option to an empty list disables
          applying the DPI bypass to any TCP connection.
        '';
      };

      allowedUDPPorts = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.port);
        default = null;
        example = [ 443 ];
        description = ''
          A list of destination UDP ports to apply the DPI bypass to. Setting
          this option to null (the default) means the DPI bypass applies to
          all UDP connections. Setting this option to an empty list disables
          applying the DPI bypass to any UDP connection.
        '';
      };

      queue = lib.mkOption {
        type = lib.types.ints.between 0 65535;
        default = 200;
        example = 400;
        description = ''
          The nfqueue queue number to use. This number must be unique between
          all other programs using nfqueue.
        '';
      };

      desyncMark = lib.mkOption {
        type = lib.types.strMatching "0x(1|2|4|8)(0)*";
        default = "0x40000000";
        example = "0x10000000";
        description = ''
          The desync mark bitmask to use. This bitmask must contain only a
          single bit, and must be unique between all other nftables rules.
        '';
        apply = lib.mapNullable lib.fromHexString;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # For the systemd nfqws@.service template unit
    systemd.packages = [ cfg.package ];

    systemd.services."nfqws2@default" = {
      overrideStrategy = "asDropin";
      aliases = [ "zapret2.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = lib.mkMerge [
        {
          ExecStart = [
            ""
            (utils.escapeSystemdExecArgs arguments)
          ];
        }
        (lib.mkIf (builtins.any (p: p.hosts.auto.enable) (builtins.attrValues cfg.profiles)) {
          StateDirectory = "zapret2";
        })
      ];
    };

    networking.nftables = lib.mkIf cfg.firewall.configureAutomatically {
      enable = true;
      tables.zapret2 = {
        family = "inet";
        content = ''
          define DESYNC_MARK = ${toString cfg.firewall.desyncMark}
          define QNUM = ${toString cfg.firewall.queue}
          ${lib.optionalString (cfg.firewall.interfaces != null) ''
            define WAN = { ${lib.concatMapStringsSep ", " (x: ''"${x}"'') cfg.firewall.interfaces} }
          ''}
          ${lib.optionalString (cfg.firewall.maxPackets != null) ''
            define PKT = 1-${toString cfg.firewall.maxPackets}
          ''}
          ${lib.optionalString (cfg.firewall.allowedTCPPorts != null && cfg.firewall.allowedTCPPorts != [ ])
            ''
              define TCP_PORT = { ${lib.concatMapStringsSep ", " toString cfg.firewall.allowedTCPPorts} }
            ''
          }
          ${lib.optionalString (cfg.firewall.allowedUDPPorts != null && cfg.firewall.allowedUDPPorts != [ ])
            ''
              define UDP_PORT = { ${lib.concatMapStringsSep ", " toString cfg.firewall.allowedUDPPorts} }
            ''
          }

          set local4 {
            type ipv4_addr
            flags interval
            elements = {
              127.0.0.0/8,
              10.0.0.0/8,
              100.64.0.0/10,
              172.16.0.0/12,
              192.168.0.0/16,
              169.254.0.0/16
            }
          }

          set local6 {
            type ipv6_addr
            flags interval
            elements = {
              ::1/128,
              fe80::/10,
              fc00::/7,
              ff00::/8
            }
          }

          chain post {
            type filter hook postrouting priority 101; policy accept;

            ${lib.concatStringsSep " " [
              (lib.optionalString (cfg.firewall.interfaces != null) "oifname $WAN")
              "ip daddr @local4 accept"
            ]}
            ${lib.concatStringsSep " " [
              (lib.optionalString (cfg.firewall.interfaces != null) "oifname $WAN")
              "ip6 daddr @local6 accept"
            ]}

            ${lib.optionalString (cfg.firewall.allowedTCPPorts != [ ]) ''
              ${lib.concatStringsSep " " [
                (lib.optionalString (cfg.firewall.interfaces != null) "oifname $WAN")
                "meta mark & $DESYNC_MARK == 0"
                "meta l4proto tcp"
                (lib.optionalString (cfg.firewall.allowedTCPPorts != null) "tcp dport $TCP_PORT")
                (lib.optionalString (cfg.firewall.maxPackets == null) "ct direction original")
                (lib.optionalString (cfg.firewall.maxPackets != null) "ct original packets $PKT")
                "queue num $QNUM bypass"
              ]}
            ''}

            ${lib.optionalString (cfg.firewall.allowedUDPPorts != [ ]) ''
              ${lib.concatStringsSep " " [
                (lib.optionalString (cfg.firewall.interfaces != null) "oifname $WAN")
                "meta mark & $DESYNC_MARK == 0"
                "meta l4proto udp"
                (lib.optionalString (cfg.firewall.allowedUDPPorts != null) "udp dport $UDP_PORT")
                (lib.optionalString (cfg.firewall.maxPackets == null) "ct direction original")
                (lib.optionalString (cfg.firewall.maxPackets != null) "ct original packets $PKT")
                "queue num $QNUM bypass"
              ]}
            ''}
          }

          chain pre {
            type filter hook prerouting priority -101; policy accept;

            ${lib.concatStringsSep " " [
              (lib.optionalString (cfg.firewall.interfaces != null) "iifname $WAN")
              "ip saddr @local4 accept"
            ]}
            ${lib.concatStringsSep " " [
              (lib.optionalString (cfg.firewall.interfaces != null) "iifname $WAN")
              "ip6 saddr @local6 accept"
            ]}

            ${lib.optionalString (cfg.firewall.allowedTCPPorts != [ ]) ''
              ${lib.concatStringsSep " " [
                (lib.optionalString (cfg.firewall.interfaces != null) "iifname $WAN")
                "meta mark & $DESYNC_MARK == 0"
                "meta l4proto tcp"
                (lib.optionalString (cfg.firewall.allowedTCPPorts != null) "tcp sport $TCP_PORT")
                (lib.optionalString (cfg.firewall.maxPackets == null) "ct direction reply")
                (lib.optionalString (cfg.firewall.maxPackets != null) "ct reply packets $PKT")
                "queue num $QNUM bypass"
              ]}
            ''}

            ${lib.optionalString (cfg.firewall.allowedUDPPorts != [ ]) ''
              ${lib.concatStringsSep " " [
                (lib.optionalString (cfg.firewall.interfaces != null) "iifname $WAN")
                "meta mark & $DESYNC_MARK == 0"
                "meta l4proto udp"
                (lib.optionalString (cfg.firewall.allowedUDPPorts != null) "udp sport $UDP_PORT")
                (lib.optionalString (cfg.firewall.maxPackets == null) "ct direction reply")
                (lib.optionalString (cfg.firewall.maxPackets != null) "ct reply packets $PKT")
                "queue num $QNUM bypass"
              ]}
            ''}
          }

          chain predefrag {
            type filter hook output priority -401; policy accept;
            meta mark & $DESYNC_MARK != 0 notrack
          }
        '';
      };
    };

    boot.kernel.sysctl = {
      # From the zapret2 quickstart example commands, the RST packets that DPI
      # systems inject can sometimes be dropped as invalid before they reach
      # nfqueue. So relax the conntrack rules so that they aren't dropped.
      "net.netfilter.nf_conntrack_tcp_be_liberal" = lib.mkDefault true;
    };
  };

  meta.maintainers = with lib.maintainers; [
    andre4ik3
  ];
}
