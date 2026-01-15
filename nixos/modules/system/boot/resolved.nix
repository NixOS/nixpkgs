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
    literalExpression
    mkIf
    mkMerge
    mkOption
    mkOptionDefault
    mkOrder
    mkRenamedOptionModule
    mkRemovedOptionModule
    optionalAttrs
    types
    ;

  cfg = config.services.resolved;

  dnsmasqResolve = config.services.dnsmasq.enable && config.services.dnsmasq.resolveLocalQueries;

  resolvedConf = settingsToSections cfg.settings;
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
        # Remember to keep this in sync to the actual settings at the bottom of the page.
        defaultText = literalExpression ''
          {
            DNS = config.networking.nameservers;
            DNSOverTLS = false;
            DNSSEC = false;
            Domains = config.networking.search;
            LLMNR = true;
          }
        '';
        type = types.attrsOf unitOption;
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

      # If updating any of these attrs, also update the defaultText above.
      services.resolved.settings.Resolve = {
        DNS = config.networking.nameservers;
        DNSOverTLS = mkOptionDefault false;
        DNSSEC = mkOptionDefault false;
        Domains = mkOptionDefault config.networking.search;
        LLMNR = mkOptionDefault true;
      };

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

      networking.resolvconf.package = pkgs.systemd;

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
