{
  config,
  lib,
  utils,
  ...
}:
let
  inherit (utils.systemdUtils.lib) settingsToSections;
  inherit (utils.systemdUtils.unitOptions) unitOption;

  inherit (lib)
    concatStringsSep
    elem
    isList
    literalExpression
    mapAttrs'
    mapAttrsToList
    mkIf
    mkMerge
    mkOption
    mkOrder
    mkRenamedOptionModule
    mkRemovedOptionModule
    nameValuePair
    optionalAttrs
    types
    ;

  cfg = config.services.resolved;

  dnsmasqResolve = config.services.dnsmasq.enable && config.services.dnsmasq.resolveLocalQueries;

  transformSettings =
    settings:
    lib.mapAttrs (
      key: value:
      # concat lists for options that should result in space-separated values
      if
        elem key [
          "DNS"
          "Domains"
          "FallbackDNS"
        ]
        && isList value
      then
        concatStringsSep " " value
      else
        value
    ) settings;

  resolvedConf = settingsToSections (transformSettings cfg.settings);

  escapeDnsTxt =
    let
      dictionary = {
        "\t" = "\\t";
        "\n" = "\\n";
        "\r" = "\\r";
        " " = "\\x20";
        "\"" = ''\\"'';
        "\\" = "\\\\";
      };
      names = builtins.attrNames dictionary;
    in
    builtins.replaceStrings names (map (n: builtins.getAttr n dictionary) names);
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "resolved" "fallbackDns" ]
      [ "services" "resolved" "settings" "Resolve" "FallbackDNS" ]
    )
    (mkRenamedOptionModule
      [ "services" "resolved" "domains" ]
      [ "services" "resolved" "settings" "Resolve" "Domains" ]
    )
    (mkRenamedOptionModule
      [ "services" "resolved" "llmnr" ]
      [ "services" "resolved" "settings" "Resolve" "LLMNR" ]
    )
    (mkRenamedOptionModule
      [ "services" "resolved" "dnssec" ]
      [ "services" "resolved" "settings" "Resolve" "DNSSEC" ]
    )
    (mkRenamedOptionModule
      [ "services" "resolved" "dnsovertls" ]
      [ "services" "resolved" "settings" "Resolve" "DNSOverTLS" ]
    )
    (mkRemovedOptionModule [
      "services"
      "resolved"
      "extraConfig"
    ] "Use services.resolved.settings instead")
  ];

  options = {
    services.resolved = {
      enable = lib.mkEnableOption "the Systemd DNS resolver daemon (systemd-resolved)";

      openFirewallMdns = lib.mkEnableOption "opening the Multicast DNS port (UDP 5353) in the firewall";

      settings.Resolve = mkOption {
        description = ''
          Settings option for systemd-resolved.
          See {manpage}`resolved.conf(5)` for all available options.
        '';
        default = { };
        type = types.submodule {
          freeformType = types.attrsOf unitOption;
          options = {
            DNS = mkOption {
              type = unitOption;
              default = config.networking.nameservers;
              defaultText = literalExpression "config.networking.nameservers";
              description = ''
                List of IP addresses to query as recursive DNS resolvers.
              '';
            };

            DNSOverTLS = mkOption {
              type = unitOption;
              default = false;
              description = ''
                Whether to use TLS encryption for DNS queries. Requires
                nameservers that support DNS-over-TLS.
              '';
            };

            DNSSEC = mkOption {
              type = unitOption;
              default = false;
              description = ''
                Whether to validate DNSSEC for DNS lookups.
              '';
            };

            Domains = mkOption {
              type = unitOption;
              default = config.networking.search;
              defaultText = literalExpression "config.networking.search";
              example = [
                "scope.example.com"
                "example.com"
              ];
              description = ''
                List of search domains used to complete unqualified name lookups.
              '';
            };

            MulticastDNS = mkOption {
              type = unitOption;
              default = true;
              example = false;
              description = ''
                Controls Multicast DNS support (RFC 6762) on the local host.

                If set to
                - `true`: Enables full Multicast DNS responder and resolver support.
                - `false`: Disables both.
                - `"resolve"`: Only resolution support is enabled, but responding is disabled.
              '';
            };
          };
        };
      };

      dnsDelegates = mkOption {
        description = ''
          dns-delegate files to be created.
          See {manpage}`systemd.dns-delegate(5)` for more info.
        '';
        default = { };
        type = types.attrsOf (
          types.submodule {
            options.Delegate = mkOption {
              description = ''
                Settings option for systemd dns-delegate files.
                See {manpage}`systemd.dns-delegate(5)` for all available options.
              '';
              type = types.submodule {
                freeformType = types.attrsOf unitOption;
              };
            };
          }
        );
      };
    };

    services.resolved.dnssd = mkOption {
      default = { };
      example = {
        http = {
          Service = {
            Name = "%H";
            Type = "_http._tcp";
            Port = 80;
            TxtText = [
              "path=/stats/index.html"
              "t=temperature_sensor"
            ];
          };
        };
      };
      description = ''
        DNS-SD configurations which specify discoverable network services
        announced in a local network with Multicast DNS broadcasts
      '';
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            freeformType = types.attrsOf unitOption;
            options = {
              Service.Name = mkOption {
                type = unitOption;
                default = name;
                example = "webserver";
                description = ''
                  An instance name of the network service as defined in the section 4.1.1 of RFC 6763

                  If undefined, the name of the attribute will be used.

                  The option supports simple specifier expansion, like %H for the hostname of the running system,
                  the list of available specifiers is documented in {manpage}`systemd.dnssd(5)`.
                '';
              };

              Service.Type = mkOption {
                type = unitOption;
                example = "_http._tcp";
                description = "A type of the network service as defined in the section 4.1.2 of RFC 6763";
              };

              Service.SubType = mkOption {
                type = unitOption;
                default = null;
                example = "_printer";
                description = "A subtype of the network service as defined in the section 7.1 of RFC 6763";
              };

              Service.Port = mkOption {
                type = unitOption;
                example = 80;
                description = "An IP port number of the network service";
              };

              Service.Priority = mkOption {
                type = unitOption;
                default = null;
                description = "A priority number set in SRV resource records corresponding to the network service";
              };

              Service.Weight = mkOption {
                type = unitOption;
                default = null;
                description = "A weight number set in SRV resource records corresponding to the network service";
              };

              Service.TxtText = mkOption {
                type = unitOption;
                example = [ "path=/portal/index.html" ];
                default = [ ];
                apply = x: concatStringsSep " " (map escapeDnsTxt x);
                description = ''
                  A list of arbitrary key/value pairs conveying additional information about the named service
                  in the corresponding TXT resource record
                '';
              };

              Service.TxtData = mkOption {
                type = unitOption;
                example = [ "path=L3BvcnRhbC9pbmRleC5odG1s" ];
                default = [ ];
                apply = x: concatStringsSep " " (map escapeDnsTxt x);
                description = ''
                  A list of arbitrary key/value pairs conveying additional information about the named service
                  in the corresponding TXT resource record where the values are base64-encoded string
                  representation of binary data

                  Note that you can avoid "Import From Derivation" by directly writing a .conf file
                  with just the Service section and a TxtData field in the "drop-in" directory for a service, i.e.
                  ```
                  environment.etc."systemd/dnssd/<name>.dnssd.d/extra.conf".source = pkgs.runCommand ...
                  ```
                '';
              };
            };
          }
        )
      );
    };

    boot.initrd.services.resolved.enable = mkOption {
      default = config.boot.initrd.systemd.network.enable;
      defaultText = "config.boot.initrd.systemd.network.enable";
      description = ''
        Whether to enable resolved for stage 1 networking.
        Uses the toplevel 'services.resolved' options for 'resolved.conf'
      '';
    };

  };

  config = mkMerge [
    (mkIf cfg.enable {

      assertions = [
        {
          assertion = !config.networking.useHostResolvConf;
          message = "Using host resolv.conf is not supported with systemd-resolved";
        }
        {
          assertion = cfg.settings.Resolve.MulticastDNS != false -> !config.services.avahi.enable;
          message = "services.resolved.multicastDns and services.avahi are incompatible";
        }
        {
          assertion = cfg.dnssd != { } -> cfg.settings.Resolve.MulticastDNS == true;
          message = "Resolve.MulticastDNS must be enabled to support DNS-SD configurations";
        }
      ];

      users.users.systemd-resolve.group = "systemd-resolve";

      # add resolve to nss hosts database if enabled and nscd enabled
      # system.nssModules is configured in nixos/modules/system/boot/systemd.nix
      # added with order 501 to allow modules to go before with mkBefore
      system.nssDatabases.hosts = (mkOrder 501 [ "resolve [!UNAVAIL=return]" ]);

      systemd.additionalUpstreamSystemUnits = [ "systemd-resolved.service" ];

      systemd.services.systemd-resolved = {
        wantedBy = [ "sysinit.target" ];
        aliases = [ "dbus-org.freedesktop.resolve1.service" ];
        reloadTriggers = [
          config.environment.etc."systemd/resolved.conf".source
        ]
        ++ mapAttrsToList (
          name: _: config.environment.etc."systemd/dns-delegate.d/${name}.dns-delegate".source
        ) cfg.dnsDelegates
        ++ mapAttrsToList (name: _: config.environment.etc."systemd/dnssd/${name}.dnssd".source) cfg.dnssd;
        stopIfChanged = false;
      };

      environment.etc = {
        "systemd/resolved.conf".text = resolvedConf;

        # symlink the dynamic stub resolver of resolv.conf as recommended by upstream:
        # https://www.freedesktop.org/software/systemd/man/systemd-resolved.html#/etc/resolv.conf
        "resolv.conf".source = "/run/systemd/resolve/stub-resolv.conf";
      }
      // optionalAttrs dnsmasqResolve {
        "dnsmasq-resolv.conf".source = "/run/systemd/resolve/resolv.conf";
      }
      // mapAttrs' (
        name: value:
        nameValuePair "systemd/dns-delegate.d/${name}.dns-delegate" {
          text = settingsToSections (transformSettings value);
        }
      ) cfg.dnsDelegates
      // mapAttrs' (name: contents: {
        name = "systemd/dnssd/${name}.dnssd";
        value.text = settingsToSections contents;
      }) cfg.dnssd;

      networking.firewall = mkIf cfg.openFirewallMdns {
        allowedUDPPorts = [ 5353 ];
      };

      # If networkmanager is enabled, ask it to interface with resolved.
      networking.networkmanager.dns = "systemd-resolved";

      # Since we explicitly provide a resolv.conf, disable resolvconf
      networking.resolvconf.enable = false;

      # ... but we still set the package for correct compatibility.
      networking.resolvconf.package = config.systemd.package;

      nix.firewall.extraNftablesRules = [
        "ip daddr { 127.0.0.53, 127.0.0.54 } udp dport 53 accept comment \"systemd-resolved listening IPs\""
      ];

    })

    (mkIf config.boot.initrd.services.resolved.enable {

      assertions = [
        {
          assertion = config.boot.initrd.systemd.enable;
          message = "'boot.initrd.services.resolved.enable' can only be enabled with systemd stage 1.";
        }
      ];

      boot.initrd.systemd = {
        contents = {
          "/etc/systemd/resolved.conf".text = resolvedConf;
        };

        tmpfiles.settings.systemd-resolved-stub."/etc/resolv.conf".L.argument =
          "/run/systemd/resolve/stub-resolv.conf";

        additionalUpstreamUnits = [ "systemd-resolved.service" ];
        users.systemd-resolve = { };
        groups.systemd-resolve = { };
        storePaths = [ "${config.boot.initrd.systemd.package}/lib/systemd/systemd-resolved" ];
        services.systemd-resolved = {
          wantedBy = [ "sysinit.target" ];
          aliases = [ "dbus-org.freedesktop.resolve1.service" ];
        };
      };

    })
  ];

}
