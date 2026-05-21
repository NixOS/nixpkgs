{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bind;

  bindPkg = config.services.bind.package;

  bindUser = "named";

  bindZoneCoerce =
    list:
    builtins.listToAttrs (
      lib.forEach list (zone: {
        name = zone.name;
        value = zone;
      })
    );

  bindRndcMacType = "hmac-sha256";

  bindRndcKeyFile = "/etc/bind/rndc.key";

  bindNamedExe = lib.getExe' bindPkg "named";

  bindRndcExe = lib.getExe' bindPkg "rndc";

  bindZoneOptions =
    { name, config, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "Name of the zone.";
        };
        master = lib.mkOption {
          description = "Master=false means slave server";
          type = lib.types.bool;
        };
        file = lib.mkOption {
          type = lib.types.either lib.types.str lib.types.path;
          description = "Zone file resource records contain columns of data, separated by whitespace, that define the record.";
        };
        masters = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "List of servers for inclusion in stub and secondary zones.";
        };
        slaves = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Addresses who may request zone transfers.";
          default = [ ];
        };
        allowQuery = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            List of address ranges allowed to query this zone. Instead of the address(es), this may instead
            contain the single string "any".
          '';
          default = [ "any" ];
        };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          description = "Extra zone config to be appended at the end of the zone section.";
          default = "";
        };
      };
    };

  testRndcKey = pkgs.writeTextFile {
    name = "testrndc.key";
    text = ''
      key "rndc-key" {
        algorithm ${bindRndcMacType};
        secret "Ini0XSebb9LrYz7zprobBLZ2iwBEK5S9vh9zj/DozR8=";
      };
    '';
  };

  testFakeDir = "/tmp/test-fake-directory-for-named-checkconf";

  confFile = pkgs.writeTextFile {
    name = "named.conf";
    checkPhase = ''
      ${lib.optionalString cfg.checkConfig ''
        echo "Checking named configuration file...";
        mkdir -p ${testFakeDir}
        ${lib.getExe' bindPkg "named-checkconf"} -z $target
      ''}

      substituteInPlace $target \
        --replace-fail ${testRndcKey} ${bindRndcKeyFile} \
        --replace-fail ${testFakeDir} ${cfg.directory}
    '';

    # The include path in the first line will be replaced in the postCheck hook.
    text = ''
      include "${testRndcKey}";
      controls {
        inet 127.0.0.1 allow {localhost;} keys {"rndc-key";};
      };

      acl cachenetworks { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on port ${toString cfg.listenOnPort} { ${
          lib.concatMapStrings (entry: " ${entry}; ") cfg.listenOn
        } };
        listen-on-v6 port ${toString cfg.listenOnIpv6Port} { ${
          lib.concatMapStrings (entry: " ${entry}; ") cfg.listenOnIpv6
        } };
        allow-query-cache { cachenetworks; };
        blackhole { badnetworks; };
        forward ${cfg.forward};
        forwarders { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "${testFakeDir}";
        pid-file "/run/named/named.pid";
        ${cfg.extraOptions}
      };

      ${cfg.extraConfig}

      ${lib.concatMapStrings (
        {
          name,
          file,
          master ? true,
          slaves ? [ ],
          masters ? [ ],
          allowQuery ? [ ],
          extraConfig ? "",
        }:
        ''
          zone "${name}" {
            type ${if master then "master" else "slave"};
            file "${file}";
            ${
              if master then
                ''
                  allow-transfer {
                    ${lib.concatMapStrings (ip: "${ip};\n") slaves}
                  };
                ''
              else
                ''
                  masters {
                    ${lib.concatMapStrings (ip: "${ip};\n") masters}
                  };
                ''
            }
            allow-query { ${lib.concatMapStrings (ip: "${ip}; ") allowQuery}};
            ${extraConfig}
          };
        ''
      ) (lib.attrValues cfg.zones)}
    '';
  };

  ## BEGIN Functions
  # Usage example
  # gen_v4_records {Proteus-Desktop = [{ipv4 = "100.89.227.22";} {ipv4 = "10.0.0.3";}]; Proteus-NUC = [{ipv4 = "100.64.161.20"; } {ipv4 = "10.0.0.2";}];}
  # => ''
  # Proteus-Desktop IN A 100.89.227.22
  # Proteus-Desktop IN A 10.0.0.3
  # Proteus-NUC IN A 100.64.161.20
  # Proteus-NUC IN A 10.0.0.2
  # ''
  gen_v4_records = lib.foldlAttrs (
    acc_1: hostname: ifaces:
    (lib.concatStrings [
      (lib.optionalString (acc_1 != "") "${acc_1}\n") # Prepend if not first loop
      (lib.foldl (
        acc_2: iface:
        (lib.concatStrings [
          (lib.optionalString (acc_2 != "") "${acc_2}\n")
          (lib.optionalString (iface.ipv4 != null) "${hostname} IN A ${iface.ipv4}")
        ])
      ) "" ifaces)
    ])
  ) "";
  gen_v6_records = lib.foldlAttrs (
    acc_1: hostname: ifaces:
    (lib.concatStrings [
      (lib.optionalString (acc_1 != "") "${acc_1}\n") # Prepend if not first loop
      (lib.foldl (
        acc_2: iface:
        (lib.concatStrings [
          (lib.optionalString (acc_2 != "") "${acc_2}\n")
          (lib.optionalString (iface.ipv6 != null) "${hostname} IN AAAA ${iface.ipv6}")
        ])
      ) "" ifaces)
    ])
  ) "";

  # gen_subdomain_records {Proteus-Desktop = [{ipv4 = "100.89.227.22"; ipv6 = "fd7a:115c:a1e0::1a01:e318"; domains.CNAME = ["garage"];} {ipv4 = "10.0.0.3"; ipv6 = "fdfe:dcba:9877::3";}]; Proteus-NUC = [{ipv4 = "100.64.161.20"; ipv6 = "fd7a:115c:a1e0::cd3a:a114"; domains = {A = ["@" "ns1" "v4"]; AAAA = ["@" "ns1" "v6"]; CNAME = ["aria2"];};} {ipv4 = "10.0.0.2"; ipv6 = "fdfe:dcba:9877::2"; domains = {A = ["ns1" "v4"]; AAAA = ["ns1" "v6"];};}];};
  # => ''
  # garage IN CNAME Proteus-Desktop
  # @ IN A 100.64.161.20
  # ns1 IN A 100.64.161.20
  # v4 IN A 100.64.161.20
  # @ IN AAAA fd7a:115c:a1e0::cd3a:a114
  # ns1 IN AAAA fd7a:115c:a1e0::cd3a:a114
  # v6 IN AAAA fd7a:115c:a1e0::cd3a:a114
  # aria2 IN CNAME Proteus-NUC
  # ns1 IN A 10.0.0.2
  # v4 IN A 10.0.0.2
  # ns1 IN AAAA fdfe:dcba:9877::2
  # v6 IN AAAA fdfe:dcba:9877::2
  # ''
  gen_subdomain_records =
    hosts_cfg:
    lib.concatLines (
      lib.foldlAttrs (
        acc_1: hostname: ifaces:
        acc_1
        ++ (lib.foldl (
          acc_2: iface:
          (
            acc_2
            ++
              (lib.foldlAttrs (
                acc_3: type: subs:
                acc_3
                ++ (map (
                  sub:
                  "${sub} IN ${type} ${
                    if type == "A" then
                      iface.ipv4
                    else if type == "AAAA" then
                      iface.ipv6
                    else if type == "CNAME" then
                      hostname
                    else
                      throw "Unsupported record type ${type}"
                  }"
                ) subs)
              ))
                [ ]
                iface.domains
          )
        ) [ ] ifaces)
      ) [ ] hosts_cfg
    );

  # Usage example
  # gen_reverse_v4_records "example.com" [{v4PrefixLen = 1; v6PrefixLen = 12;} {v4PrefixLen = 3; v6PrefixLen = 16;}] {Proteus-Desktop = [{ipv4 = "100.89.227.22"; ipv6 = "fd7a:115c:a1e0::1a01:e318"; domains.CNAME = ["garage"];} {ipv4 = "10.0.0.3"; ipv6 = "fdfe:dcba:9877::3";}]; Proteus-NUC = [{ipv4 = "100.64.161.20"; ipv6 = "fd7a:115c:a1e0::cd3a:a114"; domains = {A = ["@" "ns1" "v4"]; AAAA = ["@" "ns1" "v6"]; CNAME = ["aria2"];};} {ipv4 = "10.0.0.2"; ipv6 = "fdfe:dcba:9877::2"; domains = {A = ["ns1" "v4"]; AAAA = ["ns1" "v6"]; CNAME = ["git"];};}];}
  # {
  #   "0.0.10" = ''
  #     3 IN PTR Proteus-Desktop.example.com
  #     2 IN PTR Proteus-NUC.example.com
  #     2 IN PTR ns1.example.com.
  #     2 IN PTR v4.example.com.
  #     2 IN PTR git.example.com.
  #
  #   '';
  #   "100" = ''
  #   22.227.89 IN PTR Proteus-Desktop.example.com
  #   22.227.89 IN PTR garage.example.com.
  #   20.161.64 IN PTR Proteus-NUC.example.com
  #   20.161.64 IN PTR example.com.
  #   20.161.64 IN PTR ns1.example.com.
  #   20.161.64 IN PTR v4.example.com.
  #   20.161.64 IN PTR aria2.example.com.
  #
  #   '';
  # };
  gen_reverse_v4_records =
    domain: nets_cfg: hosts_cfg:
    lib.zipAttrsWith (_: v: lib.concatLines (builtins.concatLists v)) (
      lib.imap0 (
        net_idx: net_cfg:
        lib.foldlAttrs (
          acc_0: hostname: ifaces:
          acc_0
          // (
            let
              iface = builtins.elemAt ifaces net_idx;

              splited_ipv4 = lib.splitString "." iface.ipv4;
              prefix = builtins.concatStringsSep "." (
                lib.reverseList (lib.take net_cfg.v4PrefixLen splited_ipv4)
              );
              host_octets = builtins.concatStringsSep "." (
                lib.reverseList (lib.drop net_cfg.v4PrefixLen splited_ipv4)
              );
            in
            lib.optionalAttrs (iface.ipv4 != null) {
              ${prefix} =
                # Top merge
                (lib.optionals (acc_0 ? ${prefix}) acc_0.${prefix})
                ++ [ "${host_octets} IN PTR ${hostname}.${domain}." ]
                ++ (lib.optionals (iface ? domains) (
                  lib.foldlAttrs (
                    acc_1: type: subs:
                    acc_1
                    ++ (lib.optionals (type != "AAAA") (
                      map (
                        sub:
                        lib.optionalString (!lib.hasInfix "*" sub)
                          "${host_octets} IN PTR ${if sub != "@" then "${sub}.${domain}." else "${domain}."}"
                      ) subs
                    ))
                  ) [ ] iface.domains
                ));
            }
          )
        ) { } hosts_cfg
      ) nets_cfg
    );

  gen_reverse_v6_records =
    domain: nets_cfg: hosts_cfg:
    lib.zipAttrsWith (_: v: lib.concatLines (builtins.concatLists v)) (
      lib.imap0 (
        net_idx: net_cfg:
        lib.foldlAttrs (
          acc_0: hostname: ifaces:
          acc_0
          // (
            let
              iface = builtins.elemAt ifaces net_idx;

              # IPv6 Reverse Logic (Zero-Compression Expansion)
              # 1. Split by "::" to handle zero-compression
              # e.g., "fd7a:115c:a1e0::cd3a:a114" -> ["fd7a:115c:a1e0" "cd3a:a114"]
              split_double_colon = lib.splitString "::" iface.ipv6;

              # 2. Split the IP into a list, and pad add segments to 4 characters
              # e.g., Left part: ["fd7a" "115c" "a1e0"], right part: ["cd3a" "a114"]
              # Helper: Pad a string to 4 characters with leading zeros
              pad_hex =
                s:
                let
                  len = builtins.stringLength s;
                in
                if len == 0 then
                  "0000"
                else if len == 1 then
                  "000${s}"
                else if len == 2 then
                  "00${s}"
                else if len == 3 then
                  "0${s}"
                else
                  s;
              left_padded = map pad_hex (lib.splitString ":" (builtins.head split_double_colon));
              right_padded = map pad_hex (lib.splitString ":" (lib.last split_double_colon));

              # 3. Calculate and generate missing zero segments (IPv6 has 8 total segments)
              # e.g., Missing count is `8 - (3 + 2) = 3`, so the missing_segments is: ["0000" "0000" "0000"]
              miss_segs = builtins.genList (_: "0000") (
                8 - (builtins.length left_padded + builtins.length right_padded)
              );

              # 4. Construct the full 32-character string, iterate and break it to chars list, them reverse it
              # e.g., ["fd7a" "115c" "a1e0" "0000" "0000" "0000" "cd3a" "a114"]
              # -> ["f" "d" "7" "a" "1" "1" "5" "c" "a" "1" "e" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "c" "d" "3" "a" "a" "1" "1" "4"]
              # -> ["4" "1" "1" "a" "a" "3" "d" "c" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "e" "1" "a" "c" "5" "1" "1" "a" "7" "d" "f"]
              formated_ipv6 = lib.reverseList (
                lib.concatMap lib.stringToCharacters (left_padded ++ miss_segs ++ right_padded)
              );

              # For a /48 prefix. the PTR length is `32 - 48 / 4 = 20` hexes, and the prefix length is 12 hexes
              # ["4" "1" "1" "a" "a" "3" "d" "c" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "e" "1" "a" "c" "5" "1" "1" "a" "7" "d" "f"]
              # -> ["4" "1" "1" "a" "a" "3" "d" "c" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0" "0"]
              # -> "4.1.1.a.a.3.d.c.0.0.0.0.0.0.0.0.0.0.0.0"
              host_hexes = builtins.concatStringsSep "." (lib.take (32 - net_cfg.v6PrefixLen) formated_ipv6);
              prefix = builtins.concatStringsSep "." (lib.drop (32 - net_cfg.v6PrefixLen) formated_ipv6);
            in
            lib.optionalAttrs (iface.ipv6 != null) {
              ${prefix} =
                (lib.optionals (acc_0 ? ${prefix}) acc_0.${prefix})
                ++ [ "${host_hexes} IN PTR ${hostname}.${domain}." ]
                ++ (lib.optionals (iface ? domains) (
                  lib.foldlAttrs (
                    acc_1: type: subs:
                    acc_1
                    ++ (lib.optionals (type != "A") (
                      map (
                        sub:
                        lib.optionalString (!lib.hasInfix "*" sub)
                          "${host_hexes} IN PTR ${if sub != "@" then "${sub}.${domain}." else "${domain}."}"
                      ) subs
                    ))
                  ) [ ] iface.domains
                ));
            }
          )
        ) { } hosts_cfg
      ) nets_cfg
    );

  # Compute Dynamic State based on options
  gen_zone_head =
    _cfg: domain: with _cfg.soa; ''
      $ORIGIN ${domain}.
      $TTL ${minimal_ttl}
      @ IN SOA ${mName}. ${
        lib.replaceString "@" "." rName
      }. (${serial} ${refresh} ${retry} ${expire} ${minimal_ttl})
      ; Nameserver definitions
      @ IN NS ${mName}.
    '';
  ## END Functions

  # Generate zones dynamically based on the networks defined in the options
  processed_domains = lib.mapAttrs (
    domain: _cfg:
    let
      partial_zone_head = gen_zone_head _cfg;
      main_zone = pkgs.writeText "${_cfg.domain}.zone" (
        partial_zone_head _cfg.domain
        + ''
          ; Grouped Host Records
          ${lib.concatStringsSep "\n" (
            map (net_cfg: ''
              ${gen_v4_records _cfg.hosts}
              ${gen_v6_records _cfg.hosts}
            '') _cfg.networks
          )}
          ; Subdomain Services
          ${gen_subdomain_records _cfg.hosts}
        ''
      );
      # Generate reverse zones dynamically for all configured networks
      reverse_v4_zones = lib.mapAttrs' (
        prefix: records:
        lib.nameValuePair "${prefix}.in-addr.arpa" (
          pkgs.writeText "${prefix}.in-addr.arpa.zone" ''
            ${partial_zone_head "${prefix}.in-addr.arpa"}
            ; PTR Records
            ${records}
          ''
        )
      ) (gen_reverse_v4_records _cfg.domain _cfg.networks _cfg.hosts);
      reverse_v6_zones = lib.mapAttrs' (
        prefix: records:
        lib.nameValuePair "${prefix}.ip6.arpa" (
          pkgs.writeText "${prefix}.ip6.arpa.zone" ''
            ${partial_zone_head "${prefix}.ip6.arpa"}
            ; PTR Records
            ${records}
          ''
        )
      ) (gen_reverse_v6_records _cfg.domain _cfg.networks _cfg.hosts);
    in
    {
      zones = {
        ${_cfg.domain} = _cfg.bindZoneOptions // {
          name = _cfg.domain;
          file = if _cfg.mutable then main_zone.name else main_zone;
        };
      }
      // (builtins.mapAttrs (
        name: zone_file:
        _cfg.bindZoneOptions
        // {
          inherit name;
          file = if _cfg.mutable then zone_file.name else zone_file;
        }
      ) reverse_v4_zones)
      // (builtins.mapAttrs (
        name: zone_file:
        _cfg.bindZoneOptions
        // {
          inherit name;
          file = if _cfg.mutable then zone_file.name else zone_file;
        }
      ) reverse_v6_zones);

      # Collect all the derivation files that need to be copied if mutable = true
      inherit (_cfg) mutable;
      zone_files = [
        main_zone
      ]
      ++ (builtins.attrValues reverse_v4_zones)
      ++ (builtins.attrValues reverse_v6_zones);
    }
  ) cfg.domains;
in
{
  ###### interface

  options = {
    services.bind = {
      enable = lib.mkEnableOption "BIND domain name server";

      package = lib.mkPackageOption pkgs "bind" { };

      cacheNetworks = lib.mkOption {
        default = [
          "127.0.0.0/24"
          "::1/128"
        ];
        type = lib.types.listOf lib.types.str;
        description = ''
          What networks are allowed to use us as a resolver.  Note
          that this is for recursive queries -- all networks are
          allowed to query zones configured with the `zones` option
          by default (although this may be overridden within each
          zone's configuration, via the `allowQuery` option).
          It is recommended that you limit cacheNetworks to avoid your
          server being used for DNS amplification attacks.
        '';
      };

      blockedNetworks = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          What networks are just blocked.
        '';
      };

      ipv4Only = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Only use ipv4, even if the host supports ipv6.
        '';
      };

      forwarders = lib.mkOption {
        default = config.networking.nameservers;
        defaultText = lib.literalExpression "config.networking.nameservers";
        type = lib.types.listOf lib.types.str;
        description = ''
          List of servers we should forward requests to.
        '';
      };

      forward = lib.mkOption {
        default = "first";
        type = lib.types.enum [
          "first"
          "only"
        ];
        description = ''
          Whether to forward 'first' (try forwarding but lookup directly if forwarding fails) or 'only'.
        '';
      };

      listenOn = lib.mkOption {
        default = [ "any" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Interfaces to listen on.
        '';
      };

      listenOnPort = lib.mkOption {
        default = 53;
        type = lib.types.port;
        description = ''
          Port to listen on.
        '';
      };

      listenOnIpv6 = lib.mkOption {
        default = [ "any" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Ipv6 interfaces to listen on.
        '';
      };

      listenOnIpv6Port = lib.mkOption {
        default = 53;
        type = lib.types.port;
        description = ''
          Ipv6 port to listen on.
        '';
      };

      directory = lib.mkOption {
        type = lib.types.str;
        default = "/run/named";
        description = "Working directory of BIND.";
      };

      zones = lib.mkOption {
        default = [ ];
        type =
          with lib.types;
          coercedTo (listOf attrs) bindZoneCoerce (attrsOf (lib.types.submodule bindZoneOptions));
        description = ''
          List of zones we claim authority over.
        '';
        example = {
          "example.com" = {
            master = false;
            file = "/var/dns/example.com";
            masters = [ "192.168.0.1" ];
            slaves = [ ];
            extraConfig = "";
          };
        };
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the generated named configuration file.
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the options section of the
          generated named configuration file.
        '';
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Additional command-line arguments to pass to named.
        '';
        example = [
          "-n"
          "4"
        ];
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = confFile;
        defaultText = lib.literalExpression "confFile";
        description = ''
          Overridable config file to use for named. By default, that
          generated by nixos. If overriden, it will not be checked by
          named-checkconf.
        '';
      };

      checkConfig = lib.mkOption {
        type = lib.types.bool;
        default = lib.any (domain: !domain.mutable) (builtins.attrValues cfg.domains);
        defaultText = lib.literalExpression ''
          lib.any (domain: !domain.mutable) (builtins.attrValues config.services.bind.domains)
        '';
        description = ''
          Check configuration.

          The configuration will not be checked if you override the config file
          with `configFile`. Or you have any mutable domains under `domains.<name>`
        '';
      };
      domains = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, config, ... }:
            {
              options = {
                mutable = lib.mkEnableOption ''
                  Mutable zone files, copying them to the `services.bind.directory` during preStart to allow for dynamic DNS
                  (DDNS) updates at runtime
                '';
                bindZoneOptions = lib.mkOption {
                  type = lib.types.submodule bindZoneOptions;
                  description = ''
                    List of zones we claim authority over.
                  '';
                };
                soa = {
                  mName = lib.mkOption {
                    type = lib.types.str;
                    default = "ns1.${config.domain}";
                    description = "The primary nameserver (MNAME) to be used in the zone's SOA record.";
                  };
                  rName = lib.mkOption {
                    type = lib.types.str;
                    default = "admin@${config.domain}";
                    description = ''
                      The administrator's email address (RNAME) for the zone's SOA record. The '@' symbol will be
                      automatically replaced with a dot.
                    '';
                  };
                  serial = lib.mkOption {
                    type = lib.types.str;
                    default = "1970010100";
                    description = ''
                      The serial number of the zone, used by secondary servers to detect when the zone has been updated. Often
                      formatted as YYYYMMDDNN (e.g., 1970010100).
                    '';
                  };
                  refresh = lib.mkOption {
                    type = lib.types.str;
                    default = "1h";
                    description = ''
                      The time interval before the zone should be refreshed by secondary nameservers (e.g., '3h' for 3 hours,
                      or '10800' for seconds).
                    '';
                  };
                  retry = lib.mkOption {
                    type = lib.types.str;
                    default = "15m";
                    description = ''
                      The time interval that should elapse before a failed refresh should be retried by secondary nameservers
                      (e.g., '15m' or '900').
                    '';
                  };
                  expire = lib.mkOption {
                    type = lib.types.str;
                    default = "1w";
                    description = ''
                      The upper limit on the time interval that can elapse before the zone is no longer authoritative on
                      secondary servers if the primary is unreachable (e.g., '1w' for 1 week).
                    '';
                  };
                  minimal_ttl = lib.mkOption {
                    type = lib.types.str;
                    default = "1d";
                    description = ''
                      The minimum TTL (Time to Live) for the zone, which determines how long negative responses (NXDOMAIN) are
                      cached by resolvers (e.g., '1d' or '86400').
                    '';
                  };
                };
                domain = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  description = ''
                    The apex domain name (e.g., 'example.com'). Defaults to the attribute name of the domain definition.
                  '';
                };
                networks = lib.mkOption {
                  type = lib.types.listOf (
                    lib.types.submodule {
                      options = {
                        v4PrefixLen = lib.mkOption {
                          type = lib.types.ints.between 1 3;
                          default = 24 / 8;
                          description = ''
                            The number of octets (not bits) that make up the IPv4 network prefix to split the reverse
                            in-addr.arpa zones. For example, a value of 3 represents a /24 subnet.
                          '';
                        };
                        v6PrefixLen = lib.mkOption {
                          type = lib.types.ints.between 1 31;
                          default = 64 / 4;
                          description = ''
                            The number of hexes (not bits) that make up the IPv6 network prefix to split the reverse ip6.arpa
                            zones. For example, a value of 16 represents a /64 subnet.
                          '';
                        };
                      };
                    }
                  );
                  default = [ ];
                  description = ''
                    A list of network configurations used to generate reverse DNS (PTR) zones. The sequence of items here
                    dictates the expected order of interface definitions in the `hosts` option.
                  '';
                };
                hosts = lib.mkOption {
                  type = lib.types.attrsOf (
                    lib.types.listOf (
                      lib.types.submodule {
                        options = {
                          ipv4 = lib.mkOption {
                            type = with lib.types; nullOr str;
                            default = null;
                            description = "The IPv4 address for this host in the corresponding network.";
                          };
                          ipv6 = lib.mkOption {
                            type = with lib.types; nullOr str;
                            default = null;
                            description = "The IPv6 address for this host in the corresponding network.";
                          };
                          domains = lib.mkOption {
                            type = lib.types.submodule {
                              options = {
                                A = lib.mkOption {
                                  type = with lib.types; listOf str;
                                  default = [ ];
                                  description = "List of subdomains that should resolve to this interface's IPv4 address.";
                                };
                                AAAA = lib.mkOption {
                                  type = with lib.types; listOf str;
                                  default = [ ];
                                  description = "List of subdomains that should resolve to this interface's IPv6 address.";
                                };
                                CNAME = lib.mkOption {
                                  type = with lib.types; listOf str;
                                  default = [ ];
                                  description = ''
                                    List of subdomains that should be aliased to this host's hostname via CNAME records.
                                  '';
                                };
                              };
                            };
                            default = { };
                            description = ''
                              Additional subdomain records (A, AAAA, CNAME) attached to this network interface.
                            '';
                          };
                        };
                      }
                    )
                  );
                  default = { };
                  description = ''
                    An attribute set defining hosts and their per-network config for name resolution. The keys are the
                    hostnames. The order of interfaces in the list must strictly align with the order defined in
                    `service.bind.domains.networks`.
                  '';
                };
              };
            }
          )
        );
        default = { };
        description = ''
          Declarative configuration for BIND DNS domains, supporting automatic generation of forward zones, reverse zones,
          and subdomains based on hosts and network prefixes.
        '';
        example = {
          "example.com" = {
            networks = [
              {
                v4PrefixLen = 10 / 8;
                v6PrefixLen = 64 / 4;
              }
              {
                v4PrefixLen = 24 / 8;
                v6PrefixLen = 64 / 4;
              }
            ];
            hosts = {
              Proteus-Desktop = [
                {
                  ipv4 = "100.89.227.22";
                  ipv6 = "fd7a:115c:a1e0::1a01:e318";
                  domains.CNAME = [ "garage" ];
                }
                {
                  ipv4 = "10.0.0.3";
                  ipv6 = "fdfe:dcba:9877::3";
                }
              ];
              Proteus-NUC = [
                {
                  ipv4 = "100.64.161.20";
                  ipv6 = "fd7a:115c:a1e0::cd3a:a114";
                  domains = {
                    A = [
                      "@"
                      "ns1"
                      "v4"
                    ];
                    AAAA = [
                      "@"
                      "ns1"
                      "v6"
                    ];
                    CNAME = [ "aria2" ];
                  };
                }
                {
                  ipv4 = "10.0.0.2";
                  ipv6 = "fdfe:dcba:9877::2";
                  domains = {
                    A = [
                      "ns1"
                      "v4"
                    ];
                    AAAA = [
                      "ns1"
                      "v6"
                    ];
                  };
                }
              ];
            };
          };
        };
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.bind.zones = lib.foldlAttrs (
      acc: _: pcsd_domain:
      acc // pcsd_domain.zones
    ) { } processed_domains;

    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    users.users.${bindUser} = {
      group = bindUser;
      description = "BIND daemon user";
      isSystemUser = true;
    };
    users.groups.${bindUser} = { };

    systemd.tmpfiles.settings."bind" = lib.mkIf (cfg.directory != "/run/named") {
      ${cfg.directory} = {
        d = {
          user = bindUser;
          group = bindUser;
          age = "-";
        };
      };
    };
    systemd.services.bind = {
      description = "BIND Domain Name Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart =
        let
          # Filter out only the mutable domains
          mutable_domains = lib.filterAttrs (_: pcsd_domain: pcsd_domain.mutable) processed_domains;
          # Generate the install commands for all files (main + reverse) for each mutable domain
          installScripts = lib.mapAttrsToList (
            _: pcsd_domain:
            lib.concatMapStringsSep "\n" (
              file: "install -m 0644 ${file} ${config.services.bind.directory}/${file.name}"
            ) pcsd_domain.zone_files
          ) mutable_domains;
        in
        ''
          if ! [ -f ${bindRndcKeyFile} ]; then
            ${lib.getExe' bindPkg "rndc-confgen"} -c ${bindRndcKeyFile} -a -A ${bindRndcMacType} 2>/dev/null
          fi
        ''
        + (lib.optionalString (mutable_domains != { }) (lib.concatLines installScripts));

      serviceConfig = {
        Type = "forking"; # Set type to forking, see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900788
        ExecStart = "${bindNamedExe} ${lib.optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile} ${lib.concatStringsSep " " cfg.extraArgs}";
        ExecReload = "${bindRndcExe} -k '${bindRndcKeyFile}' reload";
        ExecStop = "${bindRndcExe} -k '${bindRndcKeyFile}' stop";
        User = bindUser;
        RuntimeDirectory = "named";
        RuntimeDirectoryPreserve = "yes";
        ConfigurationDirectory = "bind";
        ReadWritePaths = [
          (lib.mapAttrsToList (
            name: config: if (lib.hasPrefix "/" config.file) then "-${dirOf config.file}" else ""
          ) cfg.zones)
          cfg.directory
        ];
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ReadOnlyPaths = "/sys";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6 AF_NETLINK" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@mount @debug @clock @reboot @resources @privileged @obsolete acct modify_ldt add_key adjtimex clock_adjtime delete_module fanotify_init finit_module get_mempolicy init_module io_destroy io_getevents iopl ioperm io_setup io_submit io_cancel kcmp kexec_load keyctl lookup_dcookie migrate_pages move_pages open_by_handle_at perf_event_open process_vm_readv process_vm_writev ptrace remap_file_pages request_key set_mempolicy swapoff swapon uselib vmsplice";
      };

      unitConfig.Documentation = "man:named(8)";
    };
  };
}
