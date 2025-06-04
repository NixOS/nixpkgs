{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.resolved;

  dnsmasqResolve = config.services.dnsmasq.enable && config.services.dnsmasq.resolveLocalQueries;

  mdnsLlmnrOpts =
    name:
    types.submodule {
      options = {
        enable = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Whether to enable ${name} support.
          '';
        };
        resolveOnly = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Only resolve, do not respond to incoming queries.
          '';
        };
        openFirewall = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Whether to open the firewall for the required UDP port.
            Disabling this setting also disables discovering of network devices via the protocol.
          '';
        };
      };
    };

  resolvedConf =
    let
      mkMdnsLlmnr =
        option:
        if !option.enable then
          "false"
        else if option.resolveOnly then
          "resolve"
        else
          "true";
    in
    ''
      [Resolve]
      ${optionalString (
        config.networking.nameservers != [ ]
      ) "DNS=${concatStringsSep " " config.networking.nameservers}"}
      ${optionalString (cfg.fallbackDns != null) "FallbackDNS=${concatStringsSep " " cfg.fallbackDns}"}
      ${optionalString (cfg.domains != [ ]) "Domains=${concatStringsSep " " cfg.domains}"}
      MulticastDNS=${mkMdnsLlmnr cfg.mdns}
      LLMNR=${if lib.isAttrs cfg.llmnr then mkMdnsLlmnr cfg.llmnr else cfg.llmnr}
      DNSSEC=${cfg.dnssec}
      DNSOverTLS=${cfg.dnsovertls}
      ${config.services.resolved.extraConfig}
    '';

in
{

  options = {

    services.resolved.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable the systemd DNS resolver daemon, `systemd-resolved`.

        Search for `services.resolved` to see all options.
      '';
    };

    services.resolved.fallbackDns = mkOption {
      default = null;
      example = [
        "8.8.8.8"
        "2001:4860:4860::8844"
      ];
      type = types.nullOr (types.listOf types.str);
      description = ''
        A list of IPv4 and IPv6 addresses to use as the fallback DNS servers.
        If this option is null, a compiled-in list of DNS servers is used instead.
        Setting this option to an empty list will override the built-in list to an empty list, disabling fallback.
      '';
    };

    services.resolved.domains = mkOption {
      default = config.networking.search;
      defaultText = literalExpression "config.networking.search";
      example = [ "example.com" ];
      type = types.listOf types.str;
      description = ''
        A list of domains. These domains are used as search suffixes
        when resolving single-label host names (domain names which
        contain no dot), in order to qualify them into fully-qualified
        domain names (FQDNs).

        For compatibility reasons, if this setting is not specified,
        the search domains listed in
        {file}`/etc/resolv.conf` are used instead, if
        that file exists and any domains are configured in it.
      '';
    };

    services.resolved.mdns = mkOption {
      default = { };
      type = mdnsLlmnrOpts "mDNS";
      description = ''
        Controls support for Multicast DNS (mDNS, RFC 6762[2]).
      '';
    };

    services.resolved.llmnr = mkOption {
      default = { };
      type = types.either (mdnsLlmnrOpts "LLMNR") (
        types.enum [
          "true"
          "resolve"
          "false"
        ]
      );
      description = ''
        Controls support for Link-Local Multicast Name Resolution (LLMNR, RFC 4795).
      '';
    };

    services.resolved.dnssec = mkOption {
      default = "false";
      example = "true";
      type = types.enum [
        "true"
        "allow-downgrade"
        "false"
      ];
      description = ''
        If set to
        - `"true"`:
            all DNS lookups are DNSSEC-validated locally (excluding
            LLMNR and Multicast DNS). Note that this mode requires a
            DNS server that supports DNSSEC. If the DNS server does
            not properly support DNSSEC all validations will fail.
        - `"allow-downgrade"`:
            DNSSEC validation is attempted, but if the server does not
            support DNSSEC properly, DNSSEC mode is automatically
            disabled. Note that this mode makes DNSSEC validation
            vulnerable to "downgrade" attacks, where an attacker might
            be able to trigger a downgrade to non-DNSSEC mode by
            synthesizing a DNS response that suggests DNSSEC was not
            supported.
        - `"false"`: DNS lookups are not DNSSEC validated.

        At the time of September 2023, systemd upstream advise
        to disable DNSSEC by default as the current code
        is not robust enough to deal with "in the wild" non-compliant
        servers, which will usually give you a broken bad experience
        in addition of insecure.
      '';
    };

    services.resolved.dnsovertls = mkOption {
      default = "false";
      example = "true";
      type = types.enum [
        "true"
        "opportunistic"
        "false"
      ];
      description = ''
        If set to
        - `"true"`:
            all DNS lookups will be encrypted. This requires
            that the DNS server supports DNS-over-TLS and
            has a valid certificate. If the hostname was specified
            via the `address#hostname` format in {option}`services.resolved.domains`
            then the specified hostname is used to validate its certificate.
        - `"opportunistic"`:
            all DNS lookups will attempt to be encrypted, but will fallback
            to unecrypted requests if the server does not support DNS-over-TLS.
            Note that this mode does allow for a malicious party to conduct a
            downgrade attack by immitating the DNS server and pretending to not
            support encryption.
        - `"false"`:
            all DNS lookups are done unencrypted.
      '';
    };

    services.resolved.extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Extra config to append to resolved.conf.
      '';
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
          assertion = !(cfg.mdns.enable && config.services.avahi.enable);
          message = ''
            mDNS resolution cannot be handled by both systemd-resolved and
            Avahi at the same time.
          '';
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

      networking.firewall =
        let
          fromAttrs = { enable, openFirewall, ... }: enable && openFirewall;
        in
        lib.mkMerge [
          (mkIf (fromAttrs cfg.mdns) {
            allowedUDPPorts = [ 5353 ];
          })

          (mkIf (lib.isAttrs cfg.llmnr && fromAttrs cfg.llmnr) {
            allowedUDPPorts = [ 5355 ];
          })
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
