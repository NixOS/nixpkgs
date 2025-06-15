{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (utils.systemdUtils.lib)
    assertInt
    assertOnlyFields
    assertValueOneOf
    attrsToSection
    boolValues
    checkUnitConfig
    ;
  inherit (utils.systemdUtils.unitOptions)
    unitOption
    ;

  inherit (lib)
    literalExpression
    mkIf
    mkMerge
    mkOption
    mkOrder
    mkRenamedOptionModuleWith
    optionalAttrs
    types
    ;

  cfg = config.services.resolved;

  dnsmasqResolve = config.services.dnsmasq.enable && config.services.dnsmasq.resolveLocalQueries;

  resolvedConf =
    ''
      [Resolve]
      ${attrsToSection (
        {
          DNS = config.networking.nameservers;
          Domains = config.networking.search;
          LLMNR = true;
          DNSSEC = false;
          DNSOverTLS = false;
        }
        // cfg.settings
      )}
    ''
    + cfg.extraConfig;

  check.resolved = checkUnitConfig "Resolve" [
    (assertOnlyFields [
      "DNS"
      "FallbackDNS"
      "Domains"
      "LLMNR"
      "MulticastDNS"
      "DNSSEC"
      "DNSOverTLS"
      "Cache"
      "CacheFromLocalhost"
      "DNSStubListener"
      "DNSStubListenerExtra"
      "ReadEtcHosts"
      "ResolveUnicastSingleLabel"
      "StaleRetentionSec"
    ])
    (assertValueOneOf "LLMNR" (boolValues ++ [ "resolve" ]))
    (assertValueOneOf "MulticastDNS" (boolValues ++ [ "resolve" ]))
    (assertValueOneOf "DNSSEC" (boolValues ++ [ "allow-downgrade" ]))
    (assertValueOneOf "DNSOverTLS" (boolValues ++ [ "opportunistic" ]))
    (assertValueOneOf "Cache" (boolValues ++ [ "no-negative" ]))
    (assertValueOneOf "CacheFromLocalhost" boolValues)
    (assertValueOneOf "DNSStubListener" (
      boolValues
      ++ [
        "tcp"
        "udp"
      ]
    ))
    (assertValueOneOf "ReadEtcHosts" boolValues)
    (assertValueOneOf "ResolveUnicastSingleLabel" boolValues)
    (assertInt "StaleRetentionSec")
  ];

in
{
  imports = [
    (mkRenamedOptionModuleWith {
      sinceRelease = 2511;
      from = [
        "services"
        "resolved"
        "fallbackDns"
      ];
      to = [
        "services"
        "resolved"
        "settings"
        "FallbackDNS"
      ];
    })
    (mkRenamedOptionModuleWith {
      sinceRelease = 2511;
      from = [
        "services"
        "resolved"
        "domains"
      ];
      to = [
        "services"
        "resolved"
        "settings"
        "Domains"
      ];
    })
    (mkRenamedOptionModuleWith {
      sinceRelease = 2511;
      from = [
        "services"
        "resolved"
        "llmnr"
      ];
      to = [
        "services"
        "resolved"
        "settings"
        "LLMNR"
      ];
    })
    (mkRenamedOptionModuleWith {
      sinceRelease = 2511;
      from = [
        "services"
        "resolved"
        "dnssec"
      ];
      to = [
        "services"
        "resolved"
        "settings"
        "DNSSEC"
      ];
    })
    (mkRenamedOptionModuleWith {
      sinceRelease = 2511;
      from = [
        "services"
        "resolved"
        "dnsovertls"
      ];
      to = [
        "services"
        "resolved"
        "settings"
        "DNSOverTLS"
      ];
    })
  ];

  options = {
    services.resolved = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the systemd DNS resolver daemon, `systemd-resolved`.

          Search for `services.resolved` to see all options.
        '';
      };
      settings = mkOption {
        default = { };
        # We set the dafults using an attribute set merge in the conf generation, so that all defaults are not lost when one value is changed.
        defaultText = literalExpression ''
          {
            DNS = config.networking.nameservers;
            Domains = config.networking.search;
            LLMNR = true;
            DNSSEC = false;
            DNSOverTLS = false;
          }
        '';
        example = { };
        type = types.addCheck (types.attrsOf unitOption) check.resolved;
        description = ''
          Each attribute in this set specifies an option in the `[Resolve]` section of the service configuration. See {manpage}`resolved.conf(5)` for details.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra config to append to resolved.conf.
        '';
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

      systemd.additionalUpstreamSystemUnits = [
        "systemd-resolved.service"
      ];

      systemd.services.systemd-resolved = {
        wantedBy = [ "sysinit.target" ];
        aliases = [ "dbus-org.freedesktop.resolve1.service" ];
        reloadTriggers = [ config.environment.etc."systemd/resolved.conf".source ];
        stopIfChanged = false;
      };

      environment.etc =
        {
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

      networking.resolvconf.package = pkgs.systemd;

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
