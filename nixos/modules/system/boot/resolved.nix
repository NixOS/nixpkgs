{
  config,
  lib,
  pkgs,
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
    mkIf
    mkMerge
    mkOption
    mkOrder
    mkRenamedOptionModule
    mkRemovedOptionModule
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
          };
        };
      };

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
        reloadTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
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
      };

      # If networkmanager is enabled, ask it to interface with resolved.
      networking.networkmanager.dns = "systemd-resolved";

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
